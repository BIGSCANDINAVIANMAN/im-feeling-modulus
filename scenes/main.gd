extends Node2D
@onready var main = $"."
@onready var pauseMenu = $pauseMenu
@onready var player = $dumbert_head

@export var inventory: InventoryClass = preload("res://inventoryManagement/playerInventory.tres")

signal steal_limb(ind)

var r_launcher = preload("res://scenes/characters/rocket_launcher.tscn")
var g_hook = preload("res://scenes/characters/grappling_hook.tscn")
var available_arms = 2
var has_rocket = false
var has_grapple = false

var limbs = []
var dumbert_files = {
	[]: "res://scenes/characters/dumbert_head.tscn",
	["arm"]: "res://scenes/characters/dumbert_1_arm.tscn",
	["leg"]: "res://scenes/characters/dumbert_1_leg.tscn",
	["arm", "leg"]: "res://scenes/characters/dumbert_1_leg_1_arm.tscn",
	["leg", "leg"]: "res://scenes/characters/dumbert_2_legs.tscn",
	["arm", "leg", "leg"]: "res://scenes/characters/dumbert_2_legs_1_arm.tscn",
}

var grappling_hook = preload("res://scenes/characters/grappling_hook.tscn")

func _ready():
	inventory.limb_addition.connect(add_limb)
	inventory.limb_removal.connect(remove_limb)
	
func _process(delta):		
	if Input.is_action_just_pressed("esc"):
		pause()
		
	if Input.is_action_just_pressed("debug"):
		player.add_child(grappling_hook.instantiate())
		
		
func pause():
	get_tree().paused = !get_tree().paused
	pauseMenu.visible = get_tree().paused

func remove_limb(limb_name):
	#might have issues with removing nonexistent arms
	if (limb_name == "rocket_launcher"):
		if player.has_node("rocket_launcher"):
			player.get_node("rocket_launcher").queue_free()
			has_rocket = false
			updateArmCount(limb_name, false)
		return
	if (limb_name == "grappling_hook"):
		if player.has_node("grappling_hook"):
			player.get_node("grappling_hook").queue_free()
			has_grapple = false
			updateArmCount(limb_name, false)
		return
		
	
	if limbs.has(limb_name):
		updateArmCount(limb_name, false)
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
	if has_rocket:
		player.add_child(r_launcher.instantiate())
	if has_grapple:
		player.add_child(g_hook.instantiate())
	call_deferred("add_child", player)
	player.global_position = player_pos
	
func add_limb(limb_name):
	print(limb_name)
	var headToLeg = false
	if limbs == [] and limb_name == "leg":
		headToLeg = true
	#might have issues with removing nonexistent arms
	if (limb_name == "rocket_launcher"):
		if !player.has_node("rocket_launcher") && available_arms > 0:
			has_rocket = true
			player.add_child(r_launcher.instantiate())
			updateArmCount(limb_name, true)
		return
	if (limb_name == "grappling_hook"):
		if !player.has_node("grappling_hook") && available_arms > 0:
			has_grapple = true
			player.add_child(g_hook.instantiate())
			updateArmCount(limb_name, true)
		return
		
	if available_arms == 0 and limb_name == "arm":
		print("no arms")
		return
	updateArmCount(limb_name, true)
		
	limbs.append(limb_name)
	limbs.sort()
	if !dumbert_files.keys().has(limbs):
		limbs.erase(limb_name)
		limbs.sort()
		return
	var player_pos = player.global_position
	player.queue_free()
	player = load(dumbert_files[limbs]).instantiate()
	if has_rocket:
		player.add_child(r_launcher.instantiate())
	if has_grapple:
		player.add_child(g_hook.instantiate())
	call_deferred("add_child", player)
	player.global_position = player_pos
	if (headToLeg):
		player.global_position.y -= 150
	
func updateArmCount(limb_name, add: bool):
	if "rocket_launcher, grappling_hook, arm".contains(limb_name):
		if add:
			available_arms-=1
		else:
			available_arms+=1
		#should only be for 2 weapons not 2 arms
		if available_arms == 0 and has_rocket and has_grapple:
			player.dual_wielding = true
		if !(has_rocket and has_grapple):
			player.dual_wielding = false
		print(available_arms)
		
func stealLimbFromInv(limb_name):
	for i in range(inventory.slots.size()):
		if inventory.slots[i].item:
			if inventory.slots[i].item.name == limb_name:
				print("heyo")
				steal_limb.emit(i)
				break
