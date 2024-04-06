extends "res://script/Enemy.gd"

const MAX_HEALTH = 200

var target_speed = 50.0 # Desired speed in the direction of the target vector
var acceleration_time = 1.0 # Time to reach the target speed
var v0
var state = "idle"

var target: RigidBody2D

func _target_vector() -> Vector2:
	return position.direction_to(target.position)

func _on_body_entered(body: Node):
	get_damage(10)

func _physics_process(delta):
	if target == null:
		target = get_tree().get_nodes_in_group("Spaceship")[0]
	else:
		_process_state()
		if state == "hostile":
			_process_acc()
		
	_process_animation(delta)
	
func _process_animation(delta):
	if health <= 0:
		var timer = Timer.new()
		get_parent().add_child(timer)

		timer.connect("timeout", get_parent().queue_free)
		timer.set_wait_time(0.6)
		timer.start()
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "destruction"
	else:
		var acc
		if v0:
			acc  = (linear_velocity  - v0) / delta
		v0 = linear_velocity
		
		if acc and acc.abs() > Vector2.ZERO:
			if health < 70:
				$AnimatedSprite2D.animation = "damaged1"
			elif health < 50:
				$AnimatedSprite2D.animation = "damaged2"
			else: 
				$AnimatedSprite2D.play()
				$AnimatedSprite2D.animation = "go"
		else:
			$AnimatedSprite2D.stop()
			if health < 70:
				$AnimatedSprite2D.animation = "damaged1"
			elif health < 50:
				$AnimatedSprite2D.animation = "damaged2"
			else:
				$AnimatedSprite2D.animation = "default"

func _process_acc():
	var targetVector = _target_vector()
	apply_impulse(targetVector)

func _process_state():
	var parent = get_parent()
	var distance = target.position.distance_to(self.position)

	if distance > VISIBILITY_DISTANCE:
		state = "idle"
	else:
		state = "hostile"

func max_health():
	return MAX_HEALTH
