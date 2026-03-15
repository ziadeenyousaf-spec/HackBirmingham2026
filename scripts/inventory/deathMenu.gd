extends Panel

@onready var slot = $VBoxContainer/EquipSlot
@onready var revive_button = $VBoxContainer/Button

signal revive_player(item)

func _ready():
	visible = false
	revive_button.pressed.connect(_on_revive_pressed)

func open_menu():
	visible = true
	get_tree().paused = true  # pause game

func close_menu():
	visible = false
	get_tree().paused = false  # unpause

func _on_revive_pressed():
	var item_to_use = slot.slot_item if slot.slot_item != null else null
	emit_signal("revive_player", item_to_use)
	close_menu()
