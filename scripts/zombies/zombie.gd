extends RigidBody2D

var playerAttacked : bool = false
var zombieAttacked :bool = false
var health : int = 100

var player: Node=null
var hud: Node=null
var speed: float = 20
var target_pos
var isDead: bool=false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Replace with function body.
	add_to_group("zombies") 
	max_contacts_reported = 10
	contact_monitor=true
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.playerAttacking.connect(checkPlayerAttacked) #connect signal
	
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass

			
			
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # deletes the zombie when it reaches the end of the screenn

func hurt():
	if isDead:
		return
	else:
		$AnimatedSprite2D.animation = "hurt"
		$AnimatedSprite2D.play()
	
	
func die():
	if isDead:
		return
		
	isDead = true
	$AnimatedSprite2D.animation = "dead"
	$AnimatedSprite2D.play()
	#only play once
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.stop()
	queue_free()
	
func attack():
	if isDead:
		return
		
	$AnimatedSprite2D.animation="attack"
	$AnimatedSprite2D.play()

func walk():
	if isDead:
		return
		
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()

func checkPlayerAttacked():
	playerAttacked = true
	
func take_damage (dmgToTake):
	if isDead:
		return
		
	health -= dmgToTake
	print(health)
	if health <= 0:
		die()
	else:
		hurt()
		

func _on_body_entered(body: Node) -> void:
	if isDead:
		return
		
	if body.is_in_group("player"):
		if playerAttacked:
			take_damage(player.attack)
			playerAttacked=false
		else:
			attack()
			print("zombie touched player")
				


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		if isDead:
			return
		else:
			walk()
