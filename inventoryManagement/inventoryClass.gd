extends Resource

class_name InventoryClass
signal updated
signal limb_addition(limb_type)
@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			updated.emit()
			
			if i < 6:
				limb_addition.emit(slots[i].item.getType())
				#send signal to add limb
				
			return
	
func removeItemAtIndex(index: int):
	slots[index] = InventorySlot.new()
	
func insertSlot(index: int, inventorySlot: InventorySlot):
	var oldIndex: int = slots.find(inventorySlot)
	removeItemAtIndex(oldIndex)
	
	slots[index] = inventorySlot
	
func contains(s: InventorySlot):
	for i in range(slots.size()):
		if slots[i] == s:
			return i
	return -1
