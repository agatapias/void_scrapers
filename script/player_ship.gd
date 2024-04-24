extends RigidBody2D

class_name Spaceship

const MAX_HEALTH = 100
const MIN_HEALTH = 0
const INCREMENT_INTERVAL = 10

var thrust_vector = Vector2(0, -200)
var torque = 200
var _health = 0
var _frames_since_last_increment = 0

var reset_state = false

var checkpoint = {
	pos = Vector2.ZERO,
	level = 'Main'
}

@export var projectile: PackedScene
@export var inventory: Inventory

@onready var leftGunMarker = $LeftGunMarker

var gunEquipped: String = "none"  # "none" "LaserGun" "BombGun"

func _ready():
	contact_monitor = true
	max_contacts_reported = 10000
	connect("body_entered", _on_body_entered)
	set_health(MAX_HEALTH)
	inventory.itemUsed.connect(itemUsed)
	
	$WeaponSprite.visible = false

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_UP:
			if event.pressed and not event.is_echo():
				$EngineSoundEffect.playing = true
			elif not event.pressed:
				$EngineSoundEffect.playing = false

func _physics_process(delta):
	_frames_since_last_increment += 1
	if _health <= 0:
		var game_over = get_node("../UILayer/GameOver")
		var game_over_audio = get_node("../UILayer/GameOverAudio")
		game_over_audio.play()
		get_tree().paused = true
		game_over.visible = true

func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, checkpoint.pos)
		reset_state = false
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
		
	if Input.is_action_just_pressed("shoot") && gunEquipped != "none":
		shoot()

func _on_body_entered(body):
	get_damage(10)
	
	
# Health
func set_health(health):
	_health = clamp(health, MIN_HEALTH, MAX_HEALTH)
	var health_bar = get_node("../UILayer/HealthBar")
	health_bar.value = _health

func get_damage(damage):
	set_health(_health - damage)
	
func restore_health(health_points):
	set_health(_health + health_points)
	

# Actions
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
	
func save_checkpoint(_level):
	checkpoint = {pos = position, level = _level} 
	var saveAudio = get_node("../UILayer/GameSavedAudio")
	saveAudio.play()
	
func restore():
	set_health(MAX_HEALTH/2)
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	reset_state = true
	
func equipGun(gun):
	print("gun equipped")
	gunEquipped = gun
	$WeaponSprite.visible = true

func itemUsed(item):
	match item.idName:
		"LaserGun": equipGun(item.idName)
		"Fish": restore_health(10)
