extends Area2D

var thrust_vector = Vector2(0, -700)
var fighter: RigidBody2D
var vector
var rot

func _ready():
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", queue_free)
	timer.set_wait_time(5)
	timer.start()
	rot = fighter.global_transform.get_rotation()
	vector = fighter.linear_velocity
	

func _physics_process(delta):
	position += (thrust_vector.rotated(rot) + vector) * delta
	

func _on_body_entered(body):
	if body.name == "Enemy" or body.name == "Spaceship":
		body.get_damage(10)
	if body != self.fighter:
		queue_free()
