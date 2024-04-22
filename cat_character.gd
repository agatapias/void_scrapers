extends Area2D

var isSpaceshipNear = false
var spaceship = null

@export var inventory: Inventory
@export var shop: Shop

# buying selling view like Inventory -> Shop

signal merchant

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (isSpaceshipNear && Input.is_action_just_pressed("talk")):
		merchant.emit()
		#spaceship.inventory.openView()
		# open shop, pass in player inventory
		shop.openView(spaceship.inventory, inventory)


func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		spaceship = body
		isSpaceshipNear = true
		#body.inventory.isSelling = true


func _on_body_exited(body):
	if body.is_in_group("Spaceship"):
		spaceship = null
		isSpaceshipNear = false
		#body.inventory.isSelling = false
