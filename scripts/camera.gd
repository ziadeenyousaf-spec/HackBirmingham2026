extends Camera2D

# This tells the camera to look for a node named "Player" right next to it
@onready var player = get_node("../Player") 

func _process(_delta):
	# global_position prevents weird offset bugs that happen with regular position
	if player:
		global_position = player.global_position
