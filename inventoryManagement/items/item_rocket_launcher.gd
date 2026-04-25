extends "res://collectable.gd"

func _init():
	itemType = "rocket"

func collect(inventory: InventoryClass):
	#animations
	super(inventory)
