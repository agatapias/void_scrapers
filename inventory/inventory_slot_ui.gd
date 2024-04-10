extends Button

class_name Slot

@onready var itemVisual: Sprite2D = $CenterContainer/Panel/ItemDisplay

const SELECTED_SLOT = preload("res://assets/sprites/inventory/selected_slot.png")
const SLOT = preload("res://assets/sprites/inventory/unselected_slot.png")

var item: InventoryItem = null
var index = null

signal slotSelected

func prepare(pos):
	index = pos

func update(newItem: InventoryItem, isSelected: bool):
	item = newItem
	if !newItem:
		itemVisual.visible = false
		$Sprite2D.texture = SLOT
	else:
		itemVisual.visible = true
		itemVisual.texture = newItem.texture
		if isSelected:
			$Sprite2D.texture = SELECTED_SLOT
		else:
			$Sprite2D.texture = SLOT


func _on_pressed():
	$Sprite2D.texture = SELECTED_SLOT
	slotSelected.emit(item, index)

