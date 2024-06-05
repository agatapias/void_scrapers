extends Resource

class_name Inventory

const MAX_ITEMS = 12

signal update
signal open
signal cannotBuy
signal itemUsed

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

func addCoins(amount: int):
	money += amount
	update.emit()
	
func subtractCoins(amount: int):
	money -= amount
	update.emit()
	
func canSubtractCoins(amount: int):
	var tempMoney = money
	tempMoney -= amount
	if tempMoney < 0:
		return false
	else:
		return true
	
func removeItem(index):
	items[index] = null
	update.emit()
	
func contains(name):
	print(items)
	return items.filter(func(item): return item != null and item.name == name).size() > 0

func sellItem(index, cost):
	var item = items[index]
	items[index] = null
	addCoins(cost)
	return item

func buyItem(item, cost):
	insert(item)
	subtractCoins(cost)
	return true
	
func removeByName(name):
	var item = items.filter(func(item): return item != null and item.name == name)
	if item == []:
		return null
	var index = items.find(item[0])
	removeItem(index)
	return item
	
func findByName(name):
	var item = items.filter(func(item): return item != null and item.name == name)
	if item == []:
		return -1
	var index = items.find(item[0])
	return index

func useItem(index):
	var item = items[index]
	print("use item called")
	print("item name: " + str(item.name))
	print("item count: " + str(item.count))
	itemUsed.emit(item)
	if item.count <= 1:
		self.removeItem(index)
	else:
		item.count = item.count - 1
		items[index] = item
		
