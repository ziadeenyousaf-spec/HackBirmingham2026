extends CharacterBody2D

signal playerAttacking

var speed : int = 300
var health : int = 100
var enemyHealth : int = 100
var touchingEnemy : bool = false
var is_attacking: bool=false
var hud: Node=null
#@onready var anim = $AnimatedSprite

func _ready() -> void:
	add_to_group("player") 
	

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
	health -=10
	hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.updatePlayerHealth(health)
	if health<=0:
		die()

func die():
	get_tree().reload_current_scene()

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("zombies"):
		touchingEnemy = true
		print("touching enemy is true")
		take_damage()
	

func _on_area_2d_body_exited(body: Node) -> void:
	if body.is_in_group("zombies"):
		touchingEnemy = false	
