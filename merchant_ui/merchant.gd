extends Resource

class_name Merchant

const MAX_ITEMS = 12

#signal update
#
#func insert(item: InventoryItem):
	#print("items")
	#print(items)
	#var index_of_null := items.find(null)
	#if index_of_null == -1:
		## null was not found
		#print("Too much stuff in inventory!")
	#else:
		#items[index_of_null] = item
		#update.emit()
#
#func addCoins(item: InventoryItem):
	#print("add coins")
	#print("item")
	#print(item)
	#money += item.amount
	#update.emit()
	#
#func removeItem(index):
	#print("removeItem called at index:")
	#print(index)
	#items[index] = null
	#update.emit()
	#
#func sellItem(index):
	#print("sellItem called at index:")
	#print(index)
	#
#func buyItem(index):
	#print("sellItem called at index:")
	#print(index)
