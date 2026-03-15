extends Node

const MAX_SLOTS = 20
var slots = []

signal slot_changed(index)

func _ready():
	for i in range(MAX_SLOTS):
		slots.append(null)

func add_item(item):
	# Try stacking first
	for i in range(MAX_SLOTS):
		var slot = slots[i]
		if slot != null and slot.item == item:
			if slot.count < item.maxStack:
				slot.count += 1
				emit_signal("slot_changed", i)
				return true
	# Find empty slot
	for i in range(MAX_SLOTS):
		if slots[i] == null:
			slots[i] = {"item": item, "count": 1}
			emit_signal("slot_changed", i)
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
