extends Area2D

var thrust_vector = Vector2(0, -700)
@onready var spaceship: RigidBody2D = get_node("../Spaceship")
var vector
var rot

func _ready():
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", queue_free)
	timer.set_wait_time(5)
	timer.start()
	rot = spaceship.global_transform.get_rotation()
	vector = spaceship.linear_velocity
	

func _physics_process(delta):
	position += (thrust_vector.rotated(rot) + vector) * delta
	

func _on_body_entered(body):
	if body.name == "Enemy":
		body.get_damage(10)
	if !body.is_in_group("Spaceship"):
		queue_free()
