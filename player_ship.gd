extends RigidBody2D

@export var thrust = Vector2(0, -50)
var torque = 200

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up"):
		print("up pressed")
		state.apply_force(thrust.rotated(rotation))
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "go"
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.animation = "default"
		#state.apply_force(Vector2())
		
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
	state.apply_torque(rotation_direction * torque)


