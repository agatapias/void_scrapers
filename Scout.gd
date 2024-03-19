extends RigidBody2D


var target_speed = 50.0 # Desired speed in the direction of the target vector
var acceleration_time = 1.0 # Time to reach the target speed

func _target_vector():
	var spaceship = get_node("/root/Main/Spaceship")
	var position_object1 = spaceship.global_transform.origin  # or object1.translation
	var position_object2 = global_transform.origin  # or object2.translation

	return (position_object2 - position_object1).normalized()

func _physics_process(delta):
	if _target_vector() != Vector2.ZERO:
		rotate_to_target(delta)
		accelerate_to_target()

func rotate_to_target(delta):
	var target_vector = _target_vector()
	var desired_angle = target_vector.angle()
	var current_angle = rotation
	var angle_diff = fposmod(desired_angle - current_angle, 2 * PI) 

	var prediction_factor = 1.0
	var adjustment_factor = 1.0

	var predicted_angle_diff = angle_diff - angular_velocity * prediction_factor
	var torque = predicted_angle_diff * adjustment_factor

	var max_torque = 100 
	torque = clamp(torque, -max_torque, max_torque)
	apply_torque(torque)
	
func accelerate_to_target():
	var target_vector = _target_vector()
	var orientation_vector = _get_orientation_vector()
	var force = abs(orientation_vector.dot(target_vector))
	var v = Vector2(force, 0)
	
	apply_force(v.rotated(rotation)*100)
	
	
func _get_orientation_vector() -> Vector2:
	var rotation_in_radians = rotation
	return Vector2(cos(rotation_in_radians), sin(rotation_in_radians))
