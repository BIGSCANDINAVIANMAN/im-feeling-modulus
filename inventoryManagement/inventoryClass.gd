extends Resource

class_name InventoryClass
signal updated
signal limb_addition(limb_type)
signal limb_removal(limb_type)
@export var slots: Array[InventorySlot]

func insert(item: InventoryItem, start: int = 0):

	for i in range(start, slots.size()):
		if !slots[i].item:
			slots[i].item = item
			updated.emit()
			
			if i < 6:
				limb_addition.emit(slots[i].item.getType())
				#send signal to add limb
				
			return
	
func removeItemAtIndex(index: int):
	slots[index] = InventorySlot.new()

#index 1 is item in hand
func swap(index1: int, index2: int):
	var item1 = slots[index1].item
	slots[index1].item = slots[index2].item
	slots[index2].item = item1
	if index1 < 6 and index2 < 6:
		limb_addition.emit(item1.getType())
		updated.emit()
		return

	if index1 < 6:
		limb_removal.emit(item1.getType())
		limb_addition.emit(slots[index1].item.getType())
	if index2 < 6:
		limb_removal.emit(slots[index1].item.getType())
		limb_addition.emit(item1.getType())
		
	updated.emit()
	
func insertSlot(index: int, inventorySlot: InventorySlot):
	var oldIndex: int = slots.find(inventorySlot)
	removeItemAtIndex(oldIndex)
	
	slots[index] = inventorySlot
	
func contains(s: InventorySlot):
	for i in range(slots.size()):
		if slots[i] == s:
			return i
	return -1
