extends Panel

@onready var icon = $TextureRect
@onready var count_label = $Label

var slot_index : int

@export var placeholder_texture : Texture2D


func update_slot(index):

	# Ignore signals for other slots
	if index != slot_index:
		return

	var slot = Inventory.slots[slot_index]

	if slot == null:
		icon.texture = placeholder_texture
		count_label.text = ""
	else:
		icon.texture = slot.item.icon

		if slot.count > 1:
			count_label.text = str(slot.count)
		else:
			count_label.text = ""
