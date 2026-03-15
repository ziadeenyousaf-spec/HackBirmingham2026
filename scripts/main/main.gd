extends Node

@export var zombie_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/Message.hide() #hide game over message
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func game_over():
	$ZombieSpawnTimer.stop()
	$HUD.updateMessage(score) #display score 
	$StartButton.show() #go back to start
	#
	#StartTimer.stop()
	
func game_start():
	$StartTimer.start() #plays once start button is clicked
	$HUD.updateScore(0) #reset score to 0

#zombie spawn
func _on_zombie_spawn_timer_timeout() -> void:
	#spawn new zombie
	var count = get_child_count()
	var hitsTaken = 0
	
	if (count!=8): # limit to 5 on a screen
		var zombie = zombie_scene.instantiate()
		var x = [0,1000].pick_random()
		var y = randf_range(0,300)
		var velocity
		
		if (x==1000):
			zombie.get_node("AnimatedSprite2D").flip_h=true
			velocity = Vector2(randf_range(-150,-200),0)
		else:
			velocity = Vector2(randf_range(150,200),0)
			
		zombie.position = Vector2(x,y)
		zombie.linear_velocity = velocity
		
		add_child(zombie) #add zombie child to scene
		
		# zombie dies
		if hitsTaken==5:
			zombie.die()
			score = score+1 #increase score
			$HUD.updateScore(score) #update text
			
		# zombie attacks
		

		


func _on_start_timer_timeout() -> void:
	$ZombieSpawnTimer.start() # start zombie timer
	print("zombie timer started")
