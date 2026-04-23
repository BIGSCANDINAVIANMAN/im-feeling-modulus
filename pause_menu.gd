extends Control
		
func _on_resume_pressed():
	get_tree().paused = false
	get_parent().visible = false

func _on_quit_pressed() -> void:
	#save progress
	get_tree().quit()
