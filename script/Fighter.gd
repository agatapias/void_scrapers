extends "res://script/Enemy.gd"

const MAX_HEALTH = 100

var acceleration_speed = 5000.0 # Time to reach the target speed
var rotation_speed = 2.0

var state = "idle"

var target: RigidBody2D

@export var projectile: PackedScene
@onready var gunMarker = $GunMarker

var last_shot = 0
var current_time = 0

func _physics_process(delta):
	current_time = current_time + delta
	if target == null:
		target = get_tree().get_nodes_in_group("Spaceship")[0]
	else:
		_process_state()
		if state == "hostile":
			_process_movement(delta)
			_process_shooting(delta)
					
	
	_process_destruction()
		
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

func _process_movement(delta):
	var angle_diff = rotate_to_target(delta)
	if abs(angle_diff) < 0.1:
		$EngineAnimatedSprite2D.play()

		$EngineAnimatedSprite2D.animation = "engines"
		var direction_adjustment_factor = _target_vector(delta).dot(Vector2.UP.rotated(rotation))
		var velocity_adjustment_factor = min(max(linear_velocity.dot(Vector2.UP.rotated(rotation)), 1), acceleration_speed)
		apply_central_impulse(Vector2.UP.rotated(rotation) * direction_adjustment_factor * delta * acceleration_speed / velocity_adjustment_factor)
		if not $EngineAudio.playing:
			$EngineAudio.playing = true
	else:
		$EngineAnimatedSprite2D.play()
		$EngineAudio.playing = false
		$EngineAnimatedSprite2D.animation = "none";

func _process_destruction():
	if health <= 0:
		var timer = Timer.new()
		get_parent().add_child(timer)

		timer.connect("timeout", get_parent().queue_free)
		timer.set_wait_time(0.6)
		timer.start()
		$DestructionAnimatedSprite2D.play()
		$DestructionAnimatedSprite2D.animation = "destruction"
		
func _process_shooting(delta):
	var target_direction = _target_vector(delta)
	var angle_diff = (Vector2.UP.rotated(rotation).angle_to(target_direction))
	
	if abs(angle_diff) < 0.05 and current_time - last_shot > 0.5:
		_shoot()
		last_shot = current_time
		

func max_health():
	return MAX_HEALTH
	
func _shoot():
	var bullet = projectile.instantiate()
	bullet.fighter = self
	owner.add_child(bullet)
	bullet.transform = gunMarker.global_transform
	$LaserSound.playing = true
