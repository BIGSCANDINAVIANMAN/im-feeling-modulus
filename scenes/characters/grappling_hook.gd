extends Sprite2D

@onready var rope_line: Line2D = $Line2D
@onready var muzzle: Marker2D = $gunTip

@export var angle_offset_degrees: float = 0.0
@export var rotation_speed: float = 10.0

var can_fire = true
var grapple = preload("res://grapple.tscn")

@export var reel_speed: float = 400.0
@export var min_rope_length: float = 50.0
@export var max_rope_length: float = 1500.0

var active_hook: Node2D = null
var is_swinging: bool = false

var grapple_point: Vector2 = Vector2.ZERO
var current_rope_length: float = 0.0

func _ready() -> void:
	set_as_top_level(true)
	
	rope_line.top_level = true
	rope_line.visible = false
	
	rope_line.clear_points()
	rope_line.add_point(Vector2.ZERO)
	rope_line.add_point(Vector2.ZERO)

func fire_grapple():
	break_grapple()
	
	active_hook = grapple.instantiate()
	active_hook.global_rotation = global_rotation - deg_to_rad(angle_offset_degrees)
	active_hook.global_position = $Marker2D.global_position
	
	get_tree().current_scene.add_child(active_hook) 
	$Sprite2D.texture = load("res://assets/rocketLauncher + grapplingHook animations/grapplingGun_without_hook.png")
	active_hook.grapple_latched.connect(_on_hook_latched)
	
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.8, 1.2)
	$AudioStreamPlayer2D.play()
	
	can_fire = false
	await get_tree().create_timer(0.5).timeout
	can_fire = true

func _physics_process(delta: float) -> void:
	global_position.x = lerp(global_position.x, get_parent().global_position.x, 0.5)
	global_position.y = lerp(global_position.y, get_parent().global_position.y + 10, 0.5)
	
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and get_parent().hasArm) or (!get_parent().hasArm and !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)) or get_tree().current_scene.available_arms == 1:
		var mouse_pos = get_global_mouse_position()
		var direction = mouse_pos - global_position
		var target_angle = direction.angle() + deg_to_rad(angle_offset_degrees)
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	
	if Input.is_action_just_pressed("fire") and can_fire:
		fire_grapple()
		
	if is_swinging:
		var player_body = get_parent()
		var to_anchor = grapple_point - player_body.global_position
		var distance = to_anchor.length()
		
		if Input.is_action_pressed("r"):
			current_rope_length -= reel_speed * delta
			current_rope_length = max(current_rope_length, min_rope_length)

		if distance > current_rope_length:
			var rope_normal = to_anchor.normalized()
			
			var stretch_amount = distance - current_rope_length
			player_body.move_and_collide(rope_normal * stretch_amount)
			
			if player_body.linear_velocity.dot(-rope_normal) > 0:
				player_body.linear_velocity = player_body.linear_velocity.slide(-rope_normal)
				
				#if we are falling downwards, multiply our speed slightly 
				if player_body.linear_velocity.y > 0: 
					player_body.linear_velocity *= (1+ (0.02*delta))
				
				#friction
				#player_body.linear_velocity *= 0.99 
	if is_instance_valid(active_hook) and not is_swinging:
		var distance_flown = muzzle.global_position.distance_to(active_hook.global_position)
		if distance_flown > max_rope_length:
			break_grapple()		
	#draw rope
	if is_swinging:
		rope_line.visible = true
		rope_line.set_point_position(0, muzzle.global_position)
		rope_line.set_point_position(1, grapple_point)
		
	elif is_instance_valid(active_hook):
		rope_line.visible = true
		rope_line.set_point_position(0, muzzle.global_position)
		rope_line.set_point_position(1, active_hook.global_position)
		
	else:
		rope_line.visible = false
		
	if Input.is_action_just_pressed("space"):
		if is_swinging:
			print("yes")
			if !get_parent().is_on_floor():
				get_parent().apply_impulse(Vector2(0, -1000))
			break_grapple()
		
func _on_hook_latched(hook_pos: Vector2):
	is_swinging = true
	grapple_point = hook_pos
	
	current_rope_length = get_parent().global_position.distance_to(hook_pos)
	
func break_grapple():
	is_swinging = false
	if is_instance_valid(active_hook):
		active_hook.queue_free()
		$Sprite2D.texture = load("res://assets/rocketLauncher + grapplingHook animations/grapplingGun.png")
