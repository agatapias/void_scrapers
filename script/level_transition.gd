extends Area2D

@export var level = "main_2.tscn"
@export var level_node = "Main2"
var wasSpaceshipNear = false
var isSpaceshipNear = false
var alert
var spaceship

signal transition

func _ready():
	alert = get_node('../UILayer/TransitionAlert')
	spaceship = get_node('../Spaceship')


func _process(delta):
	if isSpaceshipNear and not alert.visible:
		alert.visible = true
	if not isSpaceshipNear and alert.visible:
		alert.visible = false
	if (isSpaceshipNear && Input.is_action_just_pressed("interaction")):
		var data = {level = level, level_node = level_node, items = spaceship.inventory.items, health = spaceship._health}
		transition.emit(data)

			
func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = true

func _on_body_exited(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = false
