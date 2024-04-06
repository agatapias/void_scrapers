extends Area2D

@export var item: InventoryItem

func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		body.collect(item)
		queue_free()
