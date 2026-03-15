extends Panel
class_name invSlot

@onready var icon = $TextureRect
@onready var count_label = $Label

@export var placeholder_texture : Texture2D

var slot_index : int

signal mouse_entered_slot(slot)
signal mouse_exited_slot(slot)

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	update_slot(slot_index)

func _on_mouse_entered():
	emit_signal("mouse_entered_slot", self)

func _on_mouse_exited():
	emit_signal("mouse_exited_slot", self)

func update_slot(index):
	if index != slot_index:
		return
	var slot = Inventory.slots[slot_index]
	if slot == null:
		icon.texture = placeholder_texture
		count_label.text = ""
	else:
		icon.texture = slot.item.icon
		count_label.text = str(slot.count) if slot.count > 1 else ""

# -----------------------
# Drag & Drop
# -----------------------
func _get_drag_data(position):
	var slot = Inventory.slots[slot_index]
	if slot == null:
		return null
	var drag_data = {"item": slot.item, "from": self}
	var preview = TextureRect.new()
	preview.texture = slot.item.icon
	preview.custom_minimum_size = Vector2(64,64)
	set_drag_preview(preview)
	return drag_data

func _can_drop_data(position, data):
	if data == null:
		return false
	return data.has("item")

func _drop_data(position, data):
	var item = data["item"]
	var from = data["from"]

	if from == self:
		return

	# Take the item from the source slot
	if from.has_method("take_item"):
		item = from.take_item()

	# Swap if this slot already has an item
	var current_slot = Inventory.slots[slot_index]
	if current_slot != null:
		if from.has_method("set_item"):
			from.set_item(current_slot.item)
		else:
			Inventory.add_item(current_slot.item)

	# Place the new item in this slot
	Inventory.slots[slot_index] = {"item": item, "count": 1}
	Inventory.emit_signal("slot_changed", slot_index)

# -----------------------
# Helper functions for swapping
# -----------------------
func take_item():
	var slot = Inventory.slots[slot_index]
	if slot == null:
		return null
	var item = slot.item
	Inventory.slots[slot_index] = null
	Inventory.emit_signal("slot_changed", slot_index)
	return item

func set_item(item):
	Inventory.slots[slot_index] = {"item": item, "count": 1}
	Inventory.emit_signal("slot_changed", slot_index)
