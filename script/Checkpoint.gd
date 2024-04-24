extends Area2D

var alert
var spaceship
var isSpaceshipNear = false

@export var level = 'Main'

# Called when the node enters the scene tree for the first time.
func _ready():
	alert = get_node('../../UILayer/CheckpointAlert')
	spaceship = get_node('../../Spaceship')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isSpaceshipNear and not alert.visible:
		alert.visible = true
	if not isSpaceshipNear and alert.visible:
		alert.visible = false
	if (isSpaceshipNear && Input.is_action_just_pressed("checkpoint")):
		spaceship.save_checkpoint(level)

func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = true

func _on_body_exited(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = false
