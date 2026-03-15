extends CanvasLayer

signal start_game
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("hud")

func updateScore(score):
	$Score.text=str(score)
	
func updateMessage(score):
	$Message.text="Game Over. Score: " + str(score)
	$Message.show()
	
func updatePlayerHealth(health):
	$PlayerHealth.text="Player Health: " + str(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()
