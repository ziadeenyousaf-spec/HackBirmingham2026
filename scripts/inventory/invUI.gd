extends CanvasLayer

@onready var grid = $Panel/GridContainer
@onready var equip_panel = $PanelEquip
@onready var tooltip_label = $TooltipLabel

var SlotScene = preload("res://scenes/ui/inventory_slot.tscn")
var opened = false
var hovered_slot = null

signal item_equipped(type, item)
signal item_unequipped(type, item)

func _ready():
	visible = false

	# --- Inventory slots ---
	for i in range(Inventory.MAX_SLOTS):
		var slot = SlotScene.instantiate()
		grid.add_child(slot)
		slot.slot_index = i
		slot.update_slot(i)
		Inventory.slot_changed.connect(slot.update_slot)
		slot.connect("mouse_entered_slot", Callable(self,"_on_slot_hovered"))
		slot.connect("mouse_exited_slot", Callable(self,"_on_slot_exited"))

	# --- Equipment slots ---
	_connect_equip_slots(equip_panel)


# Recursive function to find all EquipSlots in nested containers
func _connect_equip_slots(node):
	for child in node.get_children():
		if child is EquipSlot:
			# Setup slot
			child.allowed_class = child.name
			child.type_label.text = child.name
			child.connect("mouse_entered_slot", Callable(self,"_on_slot_hovered"))
			child.connect("mouse_exited_slot", Callable(self,"_on_slot_exited"))
			child.connect("item_equipped", Callable(self,"_on_item_equipped"))
			child.connect("item_unequipped", Callable(self,"_on_item_unequipped"))
		elif child.get_child_count() > 0:
			# Recurse into containers
			_connect_equip_slots(child)

func _unhandled_input(event):
	if event.is_action_pressed("toggle_inventory"):
		toggle_inventory()

func toggle_inventory():
	opened = !opened
	visible = opened

func _on_slot_hovered(slot):
	hovered_slot = slot

func _on_slot_exited(slot):
	if hovered_slot == slot:
		hovered_slot = null

func _process(delta):
	var slot_under_mouse = null

	# Inventory hover
	for child in grid.get_children():
		if child is invSlot and child.get_global_rect().has_point(get_viewport().get_mouse_position()):
			slot_under_mouse = child
			break

	# Equipment hover
	if slot_under_mouse == null:
		for child in equip_panel.get_children():
			if child is EquipSlot and child.get_global_rect().has_point(get_viewport().get_mouse_position()):
				slot_under_mouse = child
				break

	hovered_slot = slot_under_mouse

	var item = null

	if hovered_slot == null:
		tooltip_label.visible = false
		return

	if hovered_slot is EquipSlot:
		item = hovered_slot.slot_item
	elif hovered_slot is invSlot:
		var slot_data = Inventory.slots[hovered_slot.slot_index]
		if slot_data != null:
			item = slot_data.item

	if item == null:
		tooltip_label.visible = false
		return

	tooltip_label.visible = true
	var item_name = item.name if "name" in item else "Unknown"
	var item_desc = item.desc if "desc" in item else ""
	tooltip_label.text = "%s\n%s" % [item_name, item_desc]
	tooltip_label.global_position = get_viewport().get_mouse_position() + Vector2(10, 10)

func _on_item_equipped(type, item):
	print("repeater")
	emit_signal("item_equipped",type,item)

func _on_item_unequipped(type, item):
	emit_signal("item_unequipped",type,item)
