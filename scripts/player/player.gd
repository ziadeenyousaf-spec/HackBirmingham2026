extends CharacterBody2D


var speed : int = 300
var health : int = 100
var enemyHealth : int = 100
var is_attacking : bool = false
var attack : int = 100
#@onready var anim = $AnimatedSprite

func _ready():
	# Wait one frame to ensure UI exists
	await get_tree().process_frame
	var root = get_tree().current_scene
	if root == null:
		return

	var inv_ui = root.get_node_or_null("/root/TestInv/Mainscene/CanvasLayer")
	if inv_ui != null:
		inv_ui.connect("item_equipped", Callable(self, "_on_item_equipped"))
		inv_ui.connect("item_unequipped", Callable(self, "_on_item_unequipped"))
		print("loaded?")
	print("null")

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

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right",
	 "move_up", "move_down")
	velocity = input_direction * speed

func _physics_process(_delta):
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
		start_attack(attack, enemyHealth)

func start_attack(dmgToGive, eHealth):
	eHealth -= dmgToGive
	if eHealth <= 0:
		enemyDie()

func take_damage (dmgToTake):
	health -= dmgToTake
	if health <= 0:
		die()

func die():
	get_tree().reload_current_scene()

func enemyDie():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(20) 
		# Assume enemy has a take_damage function
