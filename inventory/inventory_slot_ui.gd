extends Panel

@onready var itemVisual: Sprite2D = $CenterContainer/Panel/ItemDisplay

func update(item: InventoryItem):
	if !item:
		itemVisual.visible = false
	else:
		itemVisual.visible = true
		itemVisual.texture = item.texture
