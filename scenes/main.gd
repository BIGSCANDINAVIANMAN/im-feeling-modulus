extends Node2D
@onready var main = $"."
@onready var pauseMenu = $pauseMenu
@onready var player = $dumbert_head
@export var inventory: InventoryClass = preload("res://inventoryManagement/playerInventory.tres")

var limbs = []
var dumbert_files = {
	[]: "res://scenes/characters/dumbert_head.tscn",
	["arm"]: "res://scenes/characters/dumbert_1_arm.tscn",
	["leg"]: "res://scenes/characters/dumbert_1_leg.tscn",
	["arm", "leg"]: "res://scenes/characters/dumbert_1_leg_1_arm.tscn",
	["leg", "leg"]: "res://scenes/characters/dumbert_2_legs.tscn",
	["leg", "rocket_launcher"]: "res://scenes/characters/dumbert_1_leg_rocket.tscn",
	["arm", "leg", "leg"]: "res://scenes/characters/dumbert_2_legs_1_arm.tscn",
	["arm", "leg", "rocket_launcher"]: "res://scenes/characters/dumbert_1_leg_1_arm_rocket.tscn"
}

func _ready():
	inventory.limb_addition.connect(add_limb)
	
func _process(delta):
	if Input.is_action_just_pressed("esc"):
		pause()
		
func pause():
	get_tree().paused = !get_tree().paused
	pauseMenu.visible = get_tree().paused

func remove_limb(limb_name):
	if limbs.has(limb_name):
		limbs.erase(limb_name)
		limbs.sort()
	else:
		return
	if !dumbert_files.keys().has(limbs):
		limbs.append(limb_name)
		limbs.sort()
		return
	var player_pos = player.global_position
	player.queue_free()
	player = load(dumbert_files[limbs]).instantiate()
	call_deferred("add_child", player)
	player.global_position = player_pos
	
func add_limb(limb_name):
	limbs.append(limb_name)
	limbs.sort()
	var player_pos = player.global_position
	player.queue_free()
	player = load(dumbert_files[limbs]).instantiate()
	call_deferred("add_child", player)
	player.global_position = player_pos
	
	
