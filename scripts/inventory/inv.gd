extends Node

const MAX_SLOTS := 20

signal slot_changed(index)

var slots : Array = []


func _ready():
	# Initialize empty slots
	for i in range(MAX_SLOTS):
		slots.append(null)


func add_item(item):
	# Try stacking
	for i in range(MAX_SLOTS):
		var slot = slots[i]
		if slot != null and slot.item == item and slot.count < item.maxStack:
			slot.count += 1
			slot_changed.emit(i)
			return true

	# Find empty slot
	for i in range(MAX_SLOTS):
		if slots[i] == null:
			slots[i] = {
				"item": item,
				"count": 1
			}
			slot_changed.emit(i)
			return true

	return false


func remove_item(index):
	if index < 0 or index >= MAX_SLOTS:
		return
	var slot = slots[index]
	if slot == null:
		return
	slot.count -= 1
	if slot.count <= 0:
		slots[index] = null
	slot_changed.emit(index)
