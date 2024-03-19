extends RigidBody2D

var speed = 750
var thrust_vector = Vector2(0, -750)
@onready var spaceship: RigidBody2D = get_node("../Spaceship")

func _ready():
	var vector = spaceship.global_transform.origin
	var rotation = spaceship.global_transform.get_rotation()
	print(vector)
	apply_impulse(thrust_vector.rotated(rotation))
