extends "res://collectable.gd"

func _init():
	itemType = "arm"

func collect(inventory: InventoryClass):
	#animations
	super(inventory)
