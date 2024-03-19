extends RigidBody2D

var health: float = 100.0
var target_speed = 50.0 # Desired speed in the direction of the target vector
var acceleration_time = 1.0 # Time to reach the target speed

var target: RigidBody2D

func _target_vector() -> Vector2:
	return position.direction_to(target.position)

func _physics_process(delta):
	if target == null:
		target = get_tree().get_nodes_in_group("Spaceship")[0]
	else:
		var targetVector = _target_vector()
		apply_impulse(targetVector)
