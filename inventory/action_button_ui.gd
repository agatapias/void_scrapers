extends Button

signal sellItem

func _on_pressed():
	sellItem.emit()
