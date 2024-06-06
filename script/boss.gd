extends "res://script/Enemy.gd"

const MAX_HEALTH = 500
const SHOOTING_COOLDOWN = 10
const SHOOTING_TIME = 5

var acceleration_speed = 20000.0
var rotation_speed = 250

var state = "idle"

var target: RigidBody2D
var laser: Area2D

@export var coin: PackedScene

var last_shot = 0
var current_time = 0

var rng = RandomNumberGenerator.new()

var last_started_shooting = 0
var is_shooting = false

signal defeated

func max_health():
	return MAX_HEALTH

func _physics_process(delta):
	current_time = current_time + delta
	if target == null:
		target = get_tree().get_nodes_in_group("Spaceship")[0]
	if laser == null:
		laser = $LaserBeam
	else:
		_process_state()
		if state == "hostile":
			_process_movement(delta)

	_process_destruction()

func _target_vector(delta) -> Vector2:
	return global_position.direction_to(target.position - delta*linear_velocity + delta*target.linear_velocity)
	
func _on_body_entered(body: Node):
	get_damage(10)
	
func rotate_to_target(delta):
	var target_direction = _target_vector(delta)

	var angle_diff = (Vector2.UP.rotated(rotation).angle_to(target_direction))
	
	apply_torque_impulse(rotation_speed*angle_diff)
	return angle_diff
	
func _process_state():
	var parent = get_parent()
	var distance = target.position.distance_to(self.global_position)

	if distance > VISIBILITY_DISTANCE:
		state = "idle"
	else:
		state = "hostile"
		
func show_level_transition():
	print("pretend to die, open portal")
	defeated.emit(true)
	
func _process_movement(delta):
	var angle_diff = rotate_to_target(delta)
	_process_shooting(delta, angle_diff)
	
	if abs(angle_diff) < 0.2:
		$EngineAnimatedSprite2D.play()
		$EngineAnimatedSprite2D.animation = "on"

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
		$Sprite2D.visible = false  
		$DestructionSprite2D.visible = true
		$DestructionSprite2D.play("on")

func die():
	self.visible = false
	drop_many_coins()
	get_parent().queue_free()

func drop_many_coins():
	var rand = rng.randi_range(10, 30)
	for i in rand:
		drop_coin()
	
func drop_coin():
	var randX = rng.randi_range(-20,20)
	var randY = rng.randi_range(-20,20)
	var newTransform = self.global_transform
	newTransform.x = newTransform.x + Vector2(randX, 0)
	newTransform.y = newTransform.y + Vector2(0, randY)
	var newCoin = coin.instantiate()
	owner.add_child(newCoin)
	newCoin.transform = self.global_transform
	newCoin.position.x = newCoin.position.x + randX
	newCoin.position.y = newCoin.position.y + randY

func _process_shooting(delta, angle_diff):
	if not is_shooting and current_time - last_shot > SHOOTING_COOLDOWN and abs(angle_diff) < 0.25:
		last_shot = current_time
		$LaserBeam.visible = true
		is_shooting = true
		rotation_speed = 2000

	if is_shooting and current_time - last_shot > SHOOTING_TIME:
		$LaserBeam.visible = false
		is_shooting = false
		rotation_speed = 250

func set_repulsed():
	pass


func _on_destruction_sprite_2d_animation_finished():
	show_level_transition()
	die()
