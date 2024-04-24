extends Area2D

@export var item: InventoryItem

func _ready():
	$AnimatedSprite2D.play()

func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		body.collect(item)
		queue_free()

func use(player):
	player.restore_health(10)
