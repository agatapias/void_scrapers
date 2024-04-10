extends Area2D

var isSpaceshipNear = false
var spaceship = null

@export var inventory: Inventory

signal merchant

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (isSpaceshipNear && Input.is_action_just_pressed("talk")):
		print("inteacting with character")
		merchant.emit()
		spaceship.inventory.openView()


func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		spaceship = body
		isSpaceshipNear = true
		body.inventory.isSelling = true


func _on_body_exited(body):
	if body.is_in_group("Spaceship"):
		spaceship = null
		isSpaceshipNear = false
		body.inventory.isSelling = false
