extends "res://script/Enemy.gd"

const MAX_HEALTH = 500

var acceleration_speed = 5000.0 # Time to reach the target speed
var rotation_speed = 2.0

var state = "idle"

var target: RigidBody2D

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if target == null:
		target = get_tree().get_nodes_in_group("Spaceship")[0]
	else:
		_process_state()
		if state == "hostile":
			_process_movement(delta)
		
		
func _target_vector(delta) -> Vector2:
	return position.direction_to(target.position - delta*linear_velocity + delta*target.linear_velocity)
	
func _on_body_entered(body: Node):
	get_damage(10)
	
func rotate_to_target(delta):
	var target_direction = _target_vector(delta)

	var angle_diff = (Vector2.UP.rotated(rotation).angle_to(target_direction))

	#
	#var prediction_factor = 1.0
	#var adjustment_factor = 1.0
##
#
	#var predicted_angle_diff = angle_diff - angular_velocity * prediction_factor * delta
	#var torque = predicted_angle_diff * adjustment_factor
##
#
	#var max_torque = 1000  # This should be tuned to your game's needs
	#torque = clamp(rotation_speed*torque, -max_torque, max_torque)
	#apply_torque_impulse(torque)
	
	apply_torque_impulse(angle_diff)
	return angle_diff
	
func _process_state():
	var parent = get_parent()
	var distance = target.position.distance_to(self.position)

	if distance > VISIBILITY_DISTANCE:
		state = "idle"
	else:
		state = "hostile"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process_movement(delta):
	var angle_diff = rotate_to_target(delta)
	if abs(angle_diff) < 0.1:
		var direction_adjustment_factor = _target_vector(delta).dot(Vector2.UP.rotated(rotation))
		var velocity_adjustment_factor = min(max(linear_velocity.dot(Vector2.UP.rotated(rotation)), 1), acceleration_speed)
		apply_central_impulse(Vector2.UP.rotated(rotation) * direction_adjustment_factor * delta * acceleration_speed / velocity_adjustment_factor)
	

func max_health():
	return MAX_HEALTH
