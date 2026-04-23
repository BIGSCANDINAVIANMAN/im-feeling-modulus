extends Node2D
@onready var main = $"."
@onready var pauseMenu = $pauseMenu

@onready var player = $dumbert_1_leg_1_arm
var limbs = ["arm", "leg"]
var dumbert_files = {
	["leg"]: "res://scenes/characters/dumbert_1_leg.tscn",
	["arm", "leg"]: "res://scenes/characters/dumbert_1_leg_1_arm.tscn",
	["leg", "leg"]: "",
	["arm", "leg", "leg"]: ""
}

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		pause()
		
func pause():
	get_tree().paused = !get_tree().paused
	pauseMenu.visible = get_tree().paused

func remove_limb(limb_name):
	if limbs.has(limb_name):
		limbs.erase(limb_name)
	else:
		return
	var player_pos = player.global_position
	player.queue_free()
	player = load(dumbert_files[limbs]).instantiate()
	call_deferred("add_child", player)
	player.global_position = player_pos
