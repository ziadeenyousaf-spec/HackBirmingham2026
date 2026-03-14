extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Replace with function body.
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # deletes the zombie when it reaches the end of the screenn

func hurt():
	$AnimatedSprite2D.animation = "hurt"
	$AnimatedSprite2D.play()
	
func dead():
	$AnimatedSprite2D.animation = "dead"
	$AnimatedSprite2D.play()
	#only play once
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.stop()
	
func attack():
	$AnimatedSprite2D.animation="attack"
	$AnimatedSprite2D.play()
