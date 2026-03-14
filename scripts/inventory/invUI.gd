extends CanvasLayer

@onready var grid = $Panel/GridContainer

var SlotScene = preload("res://scenes/ui/inventory_slot.tscn")

var opened = true


func _ready():

	visible = opened

	# Create 20 UI slots
	for i in range(Inventory.MAX_SLOTS):

		var slot = SlotScene.instantiate()
		grid.add_child(slot)

		slot.slot_index = i
		slot.update_slot(i)

		Inventory.slot_changed.connect(slot.update_slot)


func _unhandled_input(event):

	if event.is_action_pressed("toggle_inventory"):
		toggle_inventory()


func toggle_inventory():

	opened = !opened
	visible = opened
