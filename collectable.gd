extends RigidBody2D

@export var itemType: String
@export var itemRes: InventoryItem

func getType():
	return itemType
	
func collect(inventory: InventoryClass):
	if (itemType == "rocket" || itemType == "grappling_hook" || itemType == "arm") and get_tree().current_scene.available_arms == 0:
		inventory.insert(itemRes, 6)
	else:
		inventory.insert(itemRes)
	queue_free()
