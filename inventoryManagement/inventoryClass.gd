extends Resource

class_name InventoryClass
signal updated
@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			updated.emit()
			
			if i < 6:
				pass
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
