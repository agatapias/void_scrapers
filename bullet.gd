extends Area2D

var thrust_vector = Vector2(0, -350)
@onready var spaceship: RigidBody2D = get_node("../Spaceship")

func _ready():
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", queue_free)
	timer.set_wait_time(5)
	timer.start()

func _physics_process(delta):
	var vector = spaceship.global_transform.origin
	var rotation = spaceship.global_transform.get_rotation()
	position += thrust_vector.rotated(rotation) * delta

func _on_body_entered(body):
	if body.is_in_group("Scout"):
		print("bullet body entered")
		body.get_damage(10)
	if !body.is_in_group("Spaceship"):
		queue_free()
