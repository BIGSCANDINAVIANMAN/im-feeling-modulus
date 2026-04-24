extends RigidBody2D

@export var itemType: String
@export var itemRes: InventoryItem

func getType():
	return itemType
	
func collect(inventory: InventoryClass):
	inventory.insert(itemRes)
	queue_free()
