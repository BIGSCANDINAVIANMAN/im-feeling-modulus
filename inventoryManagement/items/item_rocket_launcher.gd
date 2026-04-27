extends "res://collectable.gd"

func _init():
	itemType = "rocket"
	add_to_group("bodyParts")

func collect(inventory: InventoryClass):
	#animations
	super(inventory)
