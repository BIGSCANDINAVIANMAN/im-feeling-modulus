extends "res://scenes/characters/dumbert.gd"

@export var max_speed = 20
var accel = 10
@export var jump_speed = 2000

var dirFacing = 1
var x = 0
var player_velocity = Vector2(0, 0)
var player_velocity_last_frame = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	if !get_tree().paused:
		collectItems()
		x = Input.get_axis("left", "right")
		if x:
			dirFacing = x
		else:
			player_velocity.x = 0
		scale.x = dirFacing
		rotation = 0
		
		if player_velocity.length() < max_speed || sign(player_velocity.x) != sign(x):
			player_velocity += Vector2(x * accel, 0)
		else:
			player_velocity.x = max_speed * sign(player_velocity.x)
		if is_on_floor():
			if Input.is_action_just_pressed("space"):
				apply_impulse(Vector2(0, -jump_speed))
				$AudioStreamPlayer2D.pitch_scale = randf_range(0.8, 1.2)
				$AudioStreamPlayer2D.play()
		
		global_position += player_velocity
		

func is_on_floor():
	#print($Area2D.get_overlapping_bodies())
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("FLOOR"):
			return true
	return false
