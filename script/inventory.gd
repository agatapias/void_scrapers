extends Resource

class_name Inventory

const MAX_ITEMS = 12

signal update
signal open

@export var items: Array[InventoryItem]
@export var money: int

var isSelling = false

func openView():
	open.emit()

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
	
func removeItem(index):
	print("removeItem called at index:")
	print(index)
	items[index] = null
	update.emit()
	
func contains(name):
	print(items)
	return items.filter(func(item): return item != null and item.name == name).size() > 0

func sellItem(index):
	print("sellItem called at index:")
	print(index)
	var item = items[index]
	items[index] = null
	addCoins(item)
	
func removeByName(name):
	var item = items.filter(func(item): return item != null and item.name == name)
	if item == []:
		return null
	var index = items.find(item[0])
	removeItem(index)
	return item
	
