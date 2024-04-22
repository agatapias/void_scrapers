extends RigidBody2D

const MAX_HEALTH = 100
const MIN_HEALTH = 0
const INCREMENT_INTERVAL = 10

var thrust_vector = Vector2(0, -200)
var torque = 200
var _health = 0
var _frames_since_last_increment = 0

@export var projectile: PackedScene
@export var inventory: Inventory

@onready var leftGunMarker = $LeftGunMarker

func _ready():
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

func _physics_process(delta):
	_frames_since_last_increment += 1

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up") and _frames_since_last_increment >= INCREMENT_INTERVAL:
		state.apply_force(thrust_vector.rotated(rotation))
		_frames_since_last_increment = 0
	if Input.is_action_pressed("ui_up"):
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "go"
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.animation = "default"

		
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
	state.apply_torque(rotation_direction * torque)
	
	if linear_velocity.length() > 50:
		state.linear_velocity = state.linear_velocity.limit_length(200)
		
	if Input.is_action_just_pressed("shoot"):
		shoot()

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
	
func shoot():
	var bullet = projectile.instantiate()
	owner.add_child(bullet)
	bullet.transform = leftGunMarker.global_transform
	$LaserSound.playing = true
	
# Collects an item and adds it to inventory
func collect(item):
	inventory.insert(item)

func collect_coin(item):
	inventory.addCoins(item)
	
#func buy_item():
	
