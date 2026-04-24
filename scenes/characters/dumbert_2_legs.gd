extends "res://scenes/characters/dumbert.gd"

@export var max_speed = 600
@export var jump_speed = 1000

func _physics_process(delta: float) -> void:
	if !get_tree().paused:
		collectItems()
		var x = Input.get_axis("left", "right")
		linear_velocity.x = x * max_speed
		if is_on_floor():
			if Input.is_action_just_pressed("space"):
				apply_impulse(Vector2(0, -jump_speed))

func is_on_floor():
	#print($Area2D.get_overlapping_bodies())
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("FLOOR"):
			return true
	return false
