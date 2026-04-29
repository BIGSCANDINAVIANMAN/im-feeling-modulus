extends RigidBody2D
class_name gremlin_thief

@export var health = 100
var limb_holding = ""
@export var max_speed = 200
@export var walk_radius = 500.0
@export var move_impulse: float = 30000.0

@onready var sprite = $sprite
@onready var arm = preload("res://body_part_arm.tscn")
@onready var leg = preload("res://body_part.tscn")
@onready var armRes = preload("res://inventoryManagement/items/arm.tres")
@onready var legRes = preload("res://inventoryManagement/items/leg.tres")
var change_dir_timer: float = 0.0
@export var min_wait_time: float = 0.3
@export var max_wait_time: float = 2.0
var direction: int = 1
var initial_pos_x

var dirRunning = 0 # for after you steal a limb

func _ready() -> void:
	initial_pos_x = global_position.x
	lock_rotation = true

func _physics_process(delta: float) -> void:
	if dirRunning != 0:
		if abs(linear_velocity.x) < max_speed * 2:
			apply_central_impulse(Vector2(move_impulse * dirRunning * delta, 0))
		return
	
	if is_on_floor():
		change_dir_timer -= delta
	
		if change_dir_timer <= 0:
			var new_dir = [1, -1].pick_random()
			
			if new_dir != direction:
				direction = new_dir
				scale.x *= -1
				$sprite.flip_v = !$sprite.flip_v
			change_dir_timer = randf_range(min_wait_time, max_wait_time)

		if abs(linear_velocity.x) < max_speed:
			apply_central_impulse((Vector2(move_impulse * direction * delta, -50)))
		

func is_on_floor():
	#print($Area2D.get_overlapping_bodies())
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("FLOOR"):
			return true

func hit(damage):
	$sprite.modulate = Color(1, 0, 0)
	var tween = get_tree().create_tween()
	tween.tween_property($sprite, "modulate", Color(1, 1, 1), 0.3)
	health -= damage
	if health <= 0:
		die()

func die():
	await get_tree().create_timer(0.25).timeout
	if limb_holding == "arm":
		var dropped_arm = arm.instantiate()
		get_tree().current_scene.call_deferred("add_child", dropped_arm)
		dropped_arm.itemRes = armRes
		dropped_arm.global_position = global_position
	if limb_holding == "leg":
		var dropped_leg = leg.instantiate()
		get_tree().current_scene.call_deferred("add_child", dropped_leg)
		dropped_leg.global_position = global_position
		dropped_leg.itemRes = legRes
		print(dropped_leg.itemRes)
		print("LEG DROPPED")
		
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
	max_speed = 350.0
	
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.1)
	$AudioStreamPlayer2D.play()

	await get_tree().create_timer(3).timeout
	dirRunning = 0
	



func _on_jump_area_body_entered(body: Node2D) -> void:
	if body.name.contains("dumbert"):
		body.apply_central_impulse(Vector2(0, -1200))
		hit(50)
	pass # Replace with function body.
