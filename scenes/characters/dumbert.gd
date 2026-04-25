extends RigidBody2D

@export var charge_time = 0.5
@export var direction = 0
static var inventory: InventoryClass = preload("res://inventoryManagement/playerInventory.tres")
static var isDumbert = true

func collectItems():
	for body in get_colliding_bodies():
		if (body.is_in_group("bodyParts")):
			body.collect(inventory)
