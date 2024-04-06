extends Resource

class_name Inventory

const MAX_ITEMS = 12

signal update

@export var items: Array[InventoryItem]
@export var money: int

func insert(item: InventoryItem):
	print("items")
	print(items)
	var index_of_null := items.find(null)
	if index_of_null == -1:
		# null was not found
		print("Too much stuff in inventory!")
	else:
		items[index_of_null] = item
		update.emit()

func addCoins(item: InventoryItem):
	print("add coins")
	print("item")
	print(item)
	money += item.amount
	update.emit()
