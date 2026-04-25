extends Area2D

@export var speed = 1000
@onready var explosion_hitbox = $explosionRadius
@export var knockback: float = 67

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta
	if position.length() > 20000:
		print("bullet out of bounds")
		queue_free()
	
func _physics_process(delta: float) -> void:
	await get_tree().create_timer(0.1).timeout
	set_physics_process(false)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	#make sure to add groups as needed, ex: enemy
	if body.is_in_group("FLOOR") or body.is_in_group("enemy"):
		#play animation
		
		for target in explosion_hitbox.get_overlapping_bodies():
			if target is RigidBody2D:
				if (target.linear_velocity.y < 0):
					target.linear_velocity.y = 0
				var direction = (target.global_position - explosion_hitbox.global_position)/(target.global_position - explosion_hitbox.global_position).length()
				target.apply_central_impulse(30 * direction * knockback)
			if target.is_in_group("enemy"):
				target.hit(35)
			if "isDumbert" in target:
				pass
		
		queue_free()
