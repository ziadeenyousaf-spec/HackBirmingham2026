extends Panel
class_name EquipSlot

@onready var icon = $TextureRect
@onready var type_label = $Label

@export var placeholder_texture : Texture2D
@export var allowed_class : String

var slot_item = null

signal item_equipped(type, item)
signal item_unequipped(type, item)

func _ready():
	icon.texture = placeholder_texture
	type_label.text = allowed_class

# ----------------
# Drag & Drop
# ----------------
func _get_drag_data(position):
	if slot_item == null:
		return null
	var drag_data = {"item": slot_item, "from": self}
	var preview = TextureRect.new()
	preview.texture = slot_item.icon
	preview.custom_minimum_size = Vector2(64,64)
	set_drag_preview(preview)
	return drag_data

func _can_drop_data(position, data):
	if data == null or not data.has("item"):
		return false
	var item = data["item"]
	return item.get_script().get_global_name() == allowed_class

func _drop_data(position, data):
	var item = data["item"]
	var from = data["from"]
	if from == self:
		return
	if from.has_method("take_item"):
		item = from.take_item()
	if slot_item != null:
		Inventory.add_item(slot_item)
		emit_signal("item_unequipped", allowed_class, slot_item)
	slot_item = item
	icon.texture = item.icon
	emit_signal("item_equipped", allowed_class, item)

func take_item():
	if slot_item == null:
		return null
	var item = slot_item
	slot_item = null
	icon.texture = placeholder_texture
	emit_signal("item_unequipped", allowed_class, item)
	return item
