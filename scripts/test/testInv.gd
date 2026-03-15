extends Node2D

func _ready():
	print("work pls")
	Inventory.add_item(preload("res://assets/items/test.tres"))
	#Inventory.add_item(preload("res://scripts/inventory/Boots.tres"))
	Inventory.add_item(preload("res://assets/items/test2.tres"))
	Inventory.add_item(preload("res://assets/items/test3.tres"))
	Inventory.add_item(preload("res://assets/items/test4.tres"))
	
