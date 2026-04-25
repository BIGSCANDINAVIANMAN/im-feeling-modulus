extends RigidBody2D
@export var tracking_speed: float = 15.0

func _integrate_forces(state):
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - $"../PinJoint2D".global_position
	var target_angle = direction.angle() + deg_to_rad(180)

	var current = state.transform.get_rotation()
	var diff = wrapf(target_angle - current, -PI, PI)

	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		state.angular_velocity = diff * tracking_speed
