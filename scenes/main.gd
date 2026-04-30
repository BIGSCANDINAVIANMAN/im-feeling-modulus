extends Node2D
@onready var main = $"."
@onready var pauseMenu = $pauseMenu
@onready var player = $dumbert_head

@export var inventory: InventoryClass = preload("res://inventoryManagement/playerInventory.tres")
@onready var invMenu = $CanvasLayer/inventory
@onready var legText1 = $Text/RichTextLabel4
@onready var changeToFell = $Text/RichTextLabel2
@onready var limbSteal = $"Text/LIMB STOLEN"
@onready var dewit = $Text/RichTextLabel13
@onready var aimInstructions = $Text/RichTextLabel15
@onready var firstGrem = $gremlin
@onready var camera = $camera
var gremCutsceneHappened = false
@onready var urRocket = $item_rocket_launcher

signal steal_limb(ind)

var r_launcher = preload("res://scenes/characters/rocket_launcher.tscn")
var g_hook = preload("res://scenes/characters/grappling_hook.tscn")
var available_arms = 2
var has_rocket = false
var has_grapple = false
var shuffleSoundPlaying = false

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

var CUTSCENING = false



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
			playShuffle()
		return
	if (limb_name == "grappling_hook"):
		if player.has_node("grappling_hook"):
			player.get_node("grappling_hook").queue_free()
			has_grapple = false
			updateArmCount(limb_name, false)
			playShuffle()
		return
		
	
	if limbs.has(limb_name):
		updateArmCount(limb_name, false)
		limbs.erase(limb_name)
		limbs.sort()
		playShuffle()
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
	if limb_name=="arm":
		player.hasArm = false
	
	if CUTSCENING:
		player.set_deferred("freeze", true)
	
func add_limb(limb_name):
	var headToLeg = false
	if (limbs == [] or limbs == ["arm"]) and limb_name == "leg":
		headToLeg = true
	#might have issues with removing nonexistent arms
	if (limb_name == "rocket_launcher"):
		if !player.has_node("rocket_launcher") && available_arms > 0:
			has_rocket = true
			player.add_child(r_launcher.instantiate())
			updateArmCount(limb_name, true)
			playShuffle()
		return
	if (limb_name == "grappling_hook"):
		if !player.has_node("grappling_hook") && available_arms > 0:
			has_grapple = true
			player.add_child(g_hook.instantiate())
			updateArmCount(limb_name, true)
			playShuffle()
		return
		
	if available_arms == 0 and limb_name == "arm":
		return
	updateArmCount(limb_name, true)
		
	limbs.append(limb_name)
	limbs.sort()
	if !dumbert_files.keys().has(limbs):
		limbs.erase(limb_name)
		limbs.sort()
		return
	playShuffle()
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
	if limb_name=="arm":
		player.hasArm = true
	
func updateArmCount(limb_name, add: bool):
	if "rocket_launcher, grappling_hook, arm".contains(limb_name):
		if add:
			available_arms-=1
		else:
			available_arms+=1
		#should only be for 2 weapons not 2 arms
		if available_arms == 0:
			player.dual_wielding = true
		else:
			player.dual_wielding = false
		
func stealLimbFromInv(limb_name):
	for i in range(inventory.slots.size()):
		if inventory.slots[i].item:
			if inventory.slots[i].item.name == limb_name:
				steal_limb.emit(i)
				break
				
var saved_actions = {}

func disable_all_inputs():
	var actions = InputMap.get_actions()
	
	for action in actions:
		if action == "esc" or not action.begins_with("ui_"):
			saved_actions[action] = InputMap.action_get_events(action)
			
			InputMap.action_erase_events(action)
	print("All inputs disabled")

func reenable_all_inputs():
	for action in saved_actions:
		for event in saved_actions[action]:
			InputMap.action_add_event(action, event)
	
	saved_actions.clear()
	print("All inputs reenabled.")
	
				
				


func _on_first_leg_body_entered(body: Node2D) -> void:
	if "isDumbert" in body:
		legText1.visible = true
		camera.zoomed = false


func _on_fell_body_entered(body: Node2D) -> void:
	if "isDumbert" in body:
		changeToFell.text = "Wow you fell... guess you gotta start over!"


func _on_gremlin_thief_body_entered(body: Node2D) -> void:
	if "isDumbert" in body and !gremCutsceneHappened:
		CUTSCENING = true
		player.set_deferred("freeze", true)
		firstGrem.set_deferred("freeze", false)
		firstGrem.set_deferred("sleeping", false)
		await get_tree().create_timer(2.5).timeout
		limbSteal.visible = true
		await get_tree().create_timer(1.0).timeout
		urRocket.set_deferred("freeze", false)
		urRocket.set_deferred("sleeping", false)
		await get_tree().create_timer(2.0).timeout
		aimInstructions.visible = true
		await get_tree().create_timer(2.0).timeout
		dewit.visible = true
		await get_tree().create_timer(1.0).timeout
		player.set_deferred("freeze", false)
		player.set_deferred("sleeping", false)
		
		CUTSCENING = false
		gremCutsceneHappened = true
		
func playBoom():
	$explosion.play()
	print("hello")
	
func inInv():
	print(invMenu.visible)
	return invMenu.visible
	
@onready var dustCloud = $dustCloud
@onready var shuffle = $shuffle
	
func playShuffle():
	dustCloud.global_position = player.global_position
	dustCloud.visible = true
	dustCloud.play()
	if !shuffle.playing:
		shuffle.play()
	await dustCloud.animation_finished
	print("hide")
	dustCloud.visible = false


func _on_deathbar_body_entered(body: Node2D) -> void:
	player.global_position = Vector2(-1600, 400)
