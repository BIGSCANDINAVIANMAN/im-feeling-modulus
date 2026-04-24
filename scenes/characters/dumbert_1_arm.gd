extends "res://scenes/characters/dumbert.gd"

func _physics_process(delta: float) -> void:
	if !get_tree().paused:
		collectItems()
