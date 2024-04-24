extends Button

signal buttonPressed

func _on_pressed():
	buttonPressed.emit()
