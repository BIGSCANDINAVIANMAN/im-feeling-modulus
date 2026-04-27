extends "res://collectable.gd"

func _init():
	itemType = "arm"
	add_to_group("bodyParts")

func collect(inventory: InventoryClass):
	#animations
	super(inventory)
