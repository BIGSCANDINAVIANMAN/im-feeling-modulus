extends RichTextLabel


# Called when the node enters the scene tree for the first time.

func _ready():
	visible = false
	await get_tree().create_timer(4.0).timeout
	visible = true
	visible_characters = 0
	
	var tween = create_tween()
	
	tween.tween_property(self, "visible_characters", get_total_character_count(), 2.0)
