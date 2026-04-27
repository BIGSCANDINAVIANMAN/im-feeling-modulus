extends "res://collectable.gd"

func _init():
	itemType = "leg"
	add_to_group("bodyParts")

func collect(inventory: InventoryClass):
	#animations
	super(inventory)
