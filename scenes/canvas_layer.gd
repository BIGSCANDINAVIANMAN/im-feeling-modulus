extends CanvasLayer

@onready var inventory = $inventory

func _ready():
	inventory.visible = false
	
func _input(event):
	if event.is_action_pressed("toggleInv"):
		inventory.toggle()
	
