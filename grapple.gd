extends Area2D

@export var speed = 2000
@export var max_distance = 5000
signal grapple_latched(latch_pos)
signal grapple_missed

var distance_traveled: float = 0.0
var is_latched: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_latched:
		return
		
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta
	distance_traveled += ((Vector2.RIGHT * speed).rotated(rotation) * delta).length()
	if distance_traveled > max_distance:
		print("grapple out of bounds")
		grapple_missed.emit()
		queue_free()
		return
	
func _physics_process(delta: float) -> void:
	await get_tree().create_timer(0.1).timeout
	set_physics_process(false)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("FLOOR"):
		#play animation
		is_latched = true
		grapple_latched.emit(global_position)
