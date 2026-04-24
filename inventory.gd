extends Control
#left off here https://www.youtube.com/watch?v=9CEUurKqfLQ&list=PLMQtM2GgbPEW__dODFVRPNF2TBry25IK4&index=4

@onready var inventory: InventoryClass = preload("res://inventoryManagement/playerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var ItemStackGuiClass = preload("res://inventoryManagement/itemStackGui.tscn")

var itemInHand: ItemStackGui
signal removePart(part: String)
signal addPart(part: String)

func _ready():
	connectSlots()
	inventory.updated.connect(update)
	update()
	
func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)	
	
func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item:
			continue
		
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)
			
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()
	
func toggle():
	visible = !visible
	
func onSlotClicked(slot):
	if slot.isEmpty() && itemInHand:
		insertItemInSlot(slot)
		if slot.index >= 0 && slot.index < 6:
			owner.add_limb(slot.getItem().getType())
		return
	if !itemInHand:
		takeItemFromSlot(slot)
	
func takeItemFromSlot(slot):
	
	if slot.index >= 0 && slot.index < 6:
		if slot.getItem():
			print(slot.getItem().getType())
			owner.remove_limb(slot.getItem().getType())
		
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()
	
	
	
func insertItemInSlot(slot):
	var item = itemInHand
	remove_child(itemInHand)
	itemInHand = null
	slot.insert(item)
	
func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2
	
	
func _input(event):
	updateItemInHand()
