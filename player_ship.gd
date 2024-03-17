extends RigidBody2D

@export var thrust = Vector2(0, -350)
var torque = 10000

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up"):
		print("up pressed")
		state.apply_force(thrust.rotated(rotation))
	#else:
		#state.apply_force(Vector2())
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
	state.apply_torque(rotation_direction * torque)
