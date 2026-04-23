extends CharacterBody2D
class_name gremlin_thief

@export var health = 100
var limb_holding = ""
@export var speed = 200
@export var walk_radius = 500

var initial_pos_x

func _ready() -> void:
	initial_pos_x = global_position.x
	velocity = Vector2(speed, 0)

func _physics_process(delta: float) -> void:
	if abs(global_position.x - initial_pos_x) >= walk_radius:
		velocity.x = -velocity.x
		scale.x = -scale.x
	if not is_on_floor():
		velocity.y += 200 # gravity
	move_and_slide()

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
	var stolen_limb = main.limbs.pick_random()
	main.remove_limb(stolen_limb)
	limb_holding = stolen_limb
