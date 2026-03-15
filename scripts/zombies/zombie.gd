extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Replace with function body.
	add_to_group("zombies") 
	max_contacts_reported = 10
	contact_monitor=true
	
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # deletes the zombie when it reaches the end of the screenn

func hurt():
	$AnimatedSprite2D.animation = "hurt"
	$AnimatedSprite2D.play()
	
func die():
	$AnimatedSprite2D.animation = "dead"
	$AnimatedSprite2D.play()
	#only play once
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.stop()
	
func attack():
	$AnimatedSprite2D.animation="attack"
	$AnimatedSprite2D.play()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("player hit")
		attack()
