extends "res://collectable.gd"

func _init():
	itemType = "leg"

func collect(inventory: InventoryClass):
	#animations
	super(inventory)
