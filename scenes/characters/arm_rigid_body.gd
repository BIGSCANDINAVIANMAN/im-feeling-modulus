extends RigidBody2D

func _integrate_forces(state):
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - $"../PinJoint2D".global_position
	var target_angle = direction.angle() + deg_to_rad(180)

	var current = state.transform.get_rotation()
	var diff = wrapf(target_angle - current, -PI, PI)

	state.angular_velocity = diff * 15.0
