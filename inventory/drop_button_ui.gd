extends Button

signal removeItem

func _on_pressed():
	removeItem.emit()
