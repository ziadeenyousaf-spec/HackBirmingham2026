extends Node

@export var zombie_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_start() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func game_over():
	$ZombieSpawnTimer.stop()
	#StartTimer.stop()
	
func game_start():
	$StartTimer.start()


func _on_zombie_spawn_timer_timeout() -> void:
	#spawn new zombie
	var zombie = zombie_scene.instantiate()

	var y = randf_range(0,300)
	zombie.position = Vector2(0,y)
	#spawn in random place on path
	#var zombie_spawn_location = $zombiePath/zombieSpawnLocation
	#zombie_spawn_location.progress_ratio = randf()
	#set zombies position to random
	#zombie.position = zombie_spawn_location.position
	#set direction perpendicular to path so it goes in
	#var direction = zombie_spawn_location.rotation + PI/2
	#add randomness in direction
	#direction += randf_range(-PI/4,PI/4)
	#zombie.rotation = direction
	#set random speed
	var velocity = Vector2(randf_range(150,200),0)
	#zombie.linear_velocity = velocity.rotated(direction)
	zombie.linear_velocity = velocity
	
	add_child(zombie) #add zombie child to scene
	print("zombie spawning")
	

func _on_start_timer_timeout() -> void:
	$ZombieSpawnTimer.start() # start zombie timer
