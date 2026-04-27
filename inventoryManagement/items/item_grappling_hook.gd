extends "res://collectable.gd"

func _init():
	itemType = "grappling_hook"
	add_to_group("bodyParts")

func collect(inventory: InventoryClass):
	#animations
	super(inventory)
