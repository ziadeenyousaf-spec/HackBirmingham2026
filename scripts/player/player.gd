extends CharacterBody2D

signal playerAttacking

var speed : int = 300
var maxHealth : int = 100 #used when reviving for OPness
var health : int = 100
var enemyHealth : int = 100
var is_attacking : bool = false
var attack : int = 100
var touchingEnemy : bool = false
var hud : Node=null
var dead = false
#@onready var anim = $AnimatedSprite

func _ready():
	# Wait one frame to ensure UI exists
	await get_tree().process_frame
	
	var death_menu = get_tree().current_scene.find_child("DeathMenu", true, false)
	if death_menu:
		death_menu.connect("revive_player", Callable(self,"_on_revive_selected"))
	var root = get_tree().current_scene
	if root == null:
		return
	
	var inv_ui = root.get_node_or_null("/root/TestInv/Mainscene/Inventory")
	if inv_ui != null:
		inv_ui.connect("item_equipped", Callable(self, "_on_item_equipped"))
		inv_ui.connect("item_unequipped", Callable(self, "_on_item_unequipped"))
		print("loaded?")
	print("null")
	add_to_group("player")

# --- Signal handlers ---
func _on_item_equipped(type: String, item):
	print("playerItemObtained")
	if item == null:
		return
	if type == "Boots":
		speed += item.speedInc
	elif type == "Weapon":
		attack += item.atkInc
	else:
		health += item.healthInc
		hud = get_tree().get_first_node_in_group("hud")
		if hud:
			hud.updatePlayerHealth(health)
		if health<=0:
			die()
		

func _on_item_unequipped(type: String, item):
	print("unequip")
	if item == null:
		return
	if type == "Boots":
		speed -= item.speedInc
	elif type == "Weapon":
		attack -= item.atkInc
	else:
		health -= item.healthInc
		hud = get_tree().get_first_node_in_group("hud")
		if hud:
			hud.updatePlayerHealth(health)
		if health<=0:
			die()

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right",
	 "move_up", "move_down")
	velocity = input_direction * speed

func _physics_process(_delta):
	if dead:#cannot move while dead 
		return
	get_input()
	move_and_slide()
	#manage_animations()

#func manage_animations ():
  
	#if vel.x > 0:
		#play_animation("MoveRight")
	#elif vel.x < 0:
		#play_animation("MoveLeft")
	#elif vel.y < 0:
	#	play_animation("MoveUp")
	#elif vel.y > 0:
	#	play_animation("MoveDown")
	#elif facingDir.x == 1:
	#	play_animation("IdleRight")
	#elif facingDir.x == -1:
	#	play_animation("IdleLeft")
	#elif facingDir.y == -1:
	#	play_animation("IdleUp")
	#elif facingDir.y == 1:
	#	play_animation("IdleDown")
		
#func play_animation (anim_name):
	#if anim.animation != anim_name:
	#	anim.play(anim_name)


func _unhandled_input(event):
	if event.is_action_pressed("attack") and not is_attacking:
		is_attacking = true
		if touchingEnemy:
			playerAttacking.emit()
			
		is_attacking=false
		#start_attack(20, enemyHealth)
		

#func start_attack(dmgToGive, eHealth):
	#is_attacking = true
	#eHealth -= dmgToGive
	#if eHealth <= 0:
		#enemyDie()

func take_damage():
	if health<=0:
		return
	health -=10
	hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.updatePlayerHealth(health)
	if health<=0:
		die()

func die():
	dead = true
	velocity = Vector2.ZERO
	global_position=Vector2(0,0)#teleport back to spawn
	var death_menu = get_tree().current_scene.find_child("DeathMenu", true, false)
	if death_menu:
		death_menu.open_menu()

func clear_items():
	for i in range(Inventory.slots.size()):
		Inventory.slots[i] = null
		Inventory.slot_changed.emit(i)

	var equip_panel = get_tree().current_scene.get_node("/root/Inventory/PanelEquip")
	if equip_panel == null:
		print("Error: PanelEquip not found!")
		return

	for container in equip_panel.get_children():
		if container == null:
			continue
		for equip in container.get_children():
			if equip is EquipSlot:
				equip.take_item()

func _on_revive_selected(item):

	if item != null:
		if item.get_script().get_global_name() == "Boots":
			speed += item.speedInc
		elif item.get_script().get_global_name() == "Weapon":
			attack += item.atkInc
		else:
			health += item.healthInc

	clear_items()
	health=maxHealth
	dead = false

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("zombies"):
		touchingEnemy = true
		print("touching enemy is true")
		take_damage()
	

func _on_area_2d_body_exited(body: Node) -> void:
	if body.is_in_group("zombies"):
		touchingEnemy = false	
