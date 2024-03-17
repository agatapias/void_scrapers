extends RigidBody2D

const MAX_HEALTH = 100
const MIN_HEALTH = 0

@export var thrust = Vector2(0, -1)
var torque = 500
var _health

func _ready():
	print("ready called")
	contact_monitor = true
	max_contacts_reported = 10000
	connect("body_entered", _on_body_entered)
	set_health(MAX_HEALTH)

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_UP:
			if event.pressed and not event.is_echo():
				$EngineSoundEffect.playing = true
			elif not event.pressed:
				$EngineSoundEffect.playing = false

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up"):
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
	
	if linear_velocity.length() > 50:
		state.linear_velocity = state.linear_velocity.limit_length(200)

func _on_body_entered(body):
	get_damage(10)
	
func set_health(health):
	_health = clamp(health, MIN_HEALTH, MAX_HEALTH)
	var health_bar = get_node("/root/Main/UILayer/HealthBar")
	health_bar.value = _health

func get_damage(damage):
	set_health(_health - damage)
	
func restore_health(health_points):
	set_health(_health + health_points)
