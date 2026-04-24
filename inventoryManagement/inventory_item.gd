extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D

func getType():
	return name
