extends RigidBody2D

const MAX_HEALTH = 100
const MIN_HEALTH = 0

@export var thrust = Vector2(0, -350)
var torque = 10000
var _health

func _ready():
	contact_monitor = true
	max_contacts_reported = 10000
	connect("body_entered", _on_body_entered)
	set_health(MAX_HEALTH)

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up"):
		state.apply_force(thrust.rotated(rotation))
	#else:
		#state.apply_force(Vector2())
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
	state.apply_torque(rotation_direction * torque)

func _on_body_entered(body):
	print(body)
	print("a")
	get_damage(10)
	
func set_health(health):
	_health = clamp(health, MIN_HEALTH, MAX_HEALTH)
	var health_bar = get_node("/root/Main/UILayer/HealthBar")
	health_bar.value = _health

func get_damage(damage):
	set_health(_health - damage)
	
func restore_health(health_points):
	set_health(_health + health_points)
	
