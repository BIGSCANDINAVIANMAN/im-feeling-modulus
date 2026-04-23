extends Node2D
@onready var main = $"."
@onready var pauseMenu = $pauseMenu
func _ready():
	pauseMenu.visible = false

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		pause()
		
func pause():
	get_tree().paused = !get_tree().paused
	pauseMenu.visible = get_tree().paused
