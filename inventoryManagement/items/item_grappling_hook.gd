extends "res://collectable.gd"

func _init():
	itemType = "grappling_hook"

func collect(inventory: InventoryClass):
	#animations
	super(inventory)
