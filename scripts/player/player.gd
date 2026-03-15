extends CharacterBody2D


var speed : int = 300
var health : int = 100
var enemyHealth : int = 100
var is_attacking : bool = false
#@onready var anim = $AnimatedSprite
var wood_count : int = 0
var metal_count : int = 0
@onready var tile_map = get_node("../TileMap/trees") 
# Make sure the name matches!

func _input(event):
	if event.is_action_pressed("interact"): 
		# Create an "interact" action in Input Map (e.g., 'E')
		harvest()

func harvest():
	# 1. Get the tile position under the player
	var player_tile_pos = tile_map.local_to_map(global_position)
	
	# 2. Get the tile data at that spot
	var data = tile_map.get_cell_tile_data(player_tile_pos)
	
	if data:
		# 3. Check the "type" we set in Step 1
		var tile_type = data.get_custom_data("type")
		
		if tile_type == "Trees":
			print("You mined a tree!")
			Inventory.add_item(preload("res://assets/items/wood.tres"))
			# 4. Remove the tree tile (replace with empty/grass)
			tile_map.erase_cell(player_tile_pos)
		elif tile_type == "Props.mine.png":
			print("You mined some metal!")
			Inventory.add_item(preload("res://assets/items/metal.tres")) 
		else:
			print("Nothing to mine here.")

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
		start_attack(20, enemyHealth)

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
