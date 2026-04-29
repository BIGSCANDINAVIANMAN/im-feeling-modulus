extends RichTextLabel


# Called when the node enters the scene tree for the first time.

func _ready():
	visible = false
	await get_tree().create_timer(5.0).timeout
	visible = true
