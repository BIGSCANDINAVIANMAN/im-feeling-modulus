extends "res://scenes/characters/dumbert.gd"

var speed = 100000

func _physics_process(delta: float) -> void:
	if !get_tree().paused:
		var x = Input.get_axis("left", "right")
		apply_torque(x * speed)
		
		collectItems()
