extends Sprite2D

@export var angle_offset_degrees: float = 0.0
@export var rotation_speed: float = 10.0

var can_fire = true
var bullet = preload("res://bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x = lerp(position.x, get_parent().position.x, 0.5)
	position.y = lerp(position.y, get_parent().position.y + 10, 0.5)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var mouse_pos = get_global_mouse_position()
		var direction = mouse_pos - global_position
		var target_angle = direction.angle() + deg_to_rad(angle_offset_degrees)
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	
	if Input.is_action_pressed("fire") && can_fire:
		var bullet_instance = bullet.instantiate()

		bullet_instance.global_rotation = global_rotation - deg_to_rad(angle_offset_degrees)

		bullet_instance.global_position = $Marker2D.global_position
		get_parent().add_child(bullet_instance)

		can_fire = false
		await get_tree().create_timer(0.5).timeout
		can_fire = true
		
