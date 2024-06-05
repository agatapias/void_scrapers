extends Area2D

@export var item: InventoryItem

func _ready():
	item.item_used.connect(use)
	$AnimatedSprite2D.play()

func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		$PickUpSound.play()
		self.visible = false
		body.collect(item)

func use(player):
	player.equipGun(10)

func _on_pick_up_sound_finished():
	print("item queue free")
	queue_free()
