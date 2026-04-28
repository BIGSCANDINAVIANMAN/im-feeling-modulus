extends "res://scenes/characters/dumbert.gd"

func _physics_process(delta: float) -> void:
	if get_tree().paused:
		return

	handle_jumping(delta)
	handle_leaning(delta)
	collectItems()

func handle_jumping(delta: float):
	if Input.is_action_pressed("space") and is_on_floor():
		charge_time = min(charge_time + delta, 1.0)
	
	if Input.is_action_just_released("space") and is_on_floor():
		#use the combined vector for the jump impulse
		var jump_dir = Vector2.UP.rotated(rotation)
		apply_impulse(jump_dir * 2200 * charge_time)
		charge_time = 0.5 #reset after jump
	elif not Input.is_action_pressed("space"):
		charge_time = 0.5 #reset if let go without jumping

func handle_leaning(delta: float):
	var x = Input.get_axis("left", "right")
	var max_rot = 0.6
	
	# 1. DEFINE SPEEDS
	var ground_speed = 3.0
	var air_speed = 3.0
	
	#can have different speeds for potential issues
	var current_target_speed = 0.0
	if x != 0:
		if is_on_floor():
			current_target_speed = x * ground_speed
		else:
			current_target_speed = x * air_speed
	#move the boyd
	if x != 0:
		# move_toward helps smooth the transition
		angular_velocity = move_toward(angular_velocity, current_target_speed, 1.0)
	else:
		#stop moving when key released
		angular_velocity = 0 

	#limit max rotation
	if rotation > max_rot:
		rotation = max_rot
		if angular_velocity > 0: angular_velocity = 0
	elif rotation < -max_rot:
		rotation = -max_rot
		if angular_velocity < 0: angular_velocity = 0
			
func is_on_floor():
	#print($Area2D.get_overlapping_bodies())
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("FLOOR"):
			return true
	return false
