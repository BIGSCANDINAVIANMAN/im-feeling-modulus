extends Area2D

@export var speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta
	
func _physics_process(delta: float) -> void:
	await get_tree().create_timer(0.1).timeout
	set_physics_process(false)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	#make sure to add groups as needed, ex: enemy
	if body.is_in_group("FLOOR"):
		queue_free()
