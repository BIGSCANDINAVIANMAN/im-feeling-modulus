extends RigidBody2D
class_name gremlin_thief

@export var health = 100
var limb_holding = ""
@export var max_speed = 200
@export var walk_radius = 500.0
@export var move_impulse: float = 3000.0

@onready var sprite = $sprite
var direction: int = 1
var initial_pos_x

var dirRunning = 0 # for after you steal a limb

func _ready() -> void:
	initial_pos_x = global_position.x
	lock_rotation = true

func _physics_process(delta: float) -> void:
	if dirRunning != 0:
		if abs(linear_velocity.x) < max_speed * 2:
			apply_central_impulse((Vector2(move_impulse*dirRunning*delta, 0)))
		return
	
	if abs(global_position.x - initial_pos_x) >= walk_radius:
		if sign(global_position.x - initial_pos_x) == sign(direction):
			dirRunning = 0
			direction *= -1
			scale.x *= -1
			$sprite.flip_v = !$sprite.flip_v
	if abs(linear_velocity.x) < max_speed:
		apply_central_impulse((Vector2(move_impulse*direction*delta, 0)))

func hit(damage):
	$sprite.modulate = Color(1, 0, 0)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "modulate", Color(1, 1, 1), 1.0)
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.name.contains("dumbert") and limb_holding == "":
		steal_limb()

func steal_limb():
	var main = get_parent()
	if main.limbs.size() == 0: return
	var stolen_limb = main.limbs.pick_random()
	main.remove_limb(stolen_limb)
	main.stealLimbFromInv(stolen_limb)
	limb_holding = stolen_limb
	
	dirRunning = sign(global_position.x - get_parent().player.global_position.x)
	await get_tree().create_timer(2).timeout
	dirRunning = 0
	
