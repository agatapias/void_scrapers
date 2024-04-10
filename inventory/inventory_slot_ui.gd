extends Button

class_name Slot

@onready var itemVisual: Sprite2D = $CenterContainer/Panel/ItemDisplay
var item: InventoryItem = null

signal slotSelected

func update(newItem: InventoryItem):
	item = newItem
	if !newItem:
		itemVisual.visible = false
	else:
		itemVisual.visible = true
		itemVisual.texture = newItem.texture


func _on_pressed():
	slotSelected.emit(item)

