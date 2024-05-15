extends Area2D

@export var item: InventoryItem

func _ready():
	$AnimatedSprite2D.play()

func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		$CollectSound.playing = true
		body.collect_coin(item)
		$AnimatedSprite2D.visible = false
		_start_death_timer()

func _start_death_timer():
	$Timer.connect("timeout", _kill_node)
	$Timer.one_shot = true
	$Timer.wait_time = 2.0
	$Timer.start()

func _kill_node():
	print("killing node")
	queue_free()

	
