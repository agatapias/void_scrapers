extends RigidBody2D

class_name Spaceship

const MAX_HEALTH = 100
const MIN_HEALTH = 0
const INCREMENT_INTERVAL = 10

var thrust_vector = Vector2(0, -200)
var suck_vector = Vector2(0, -100)
var torque = 200
var _health = 0
var _frames_since_last_increment = 0

var suckingGravities = []
var reset_state = false

var hasShieldEquipped = false

var checkpoint = {
	pos = Vector2.ZERO,
	level = 'Main'
}

var isIntenseEngine = false

var rng = RandomNumberGenerator.new()

@export var projectile: PackedScene
@export var bomb: PackedScene
@export var gravitySpiral: PackedScene
@export var inventory: Inventory

@onready var leftGunMarker = $LeftGunMarker

var gunEquipped: String = "none"  # "none" "LaserGun" "BombGun"

func _target_vector(gravity) -> Vector2:
	return position.direction_to(gravity.position)

func _target_rotation(gravity) -> Vector2:
	return position.direction_to(gravity.rotation)

func _ready():
	contact_monitor = true
	max_contacts_reported = 10000
	connect("body_entered", _on_body_entered)
	drop_shield()
	set_health(MAX_HEALTH)
	inventory.itemUsed.connect(itemUsed)
	setTimerRandom()
	
	$WeaponSprite.visible = false
	
	if get_parent().name == 'Main3':
		equipGun("gun")

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
		var game_over = get_node("../UILayer/GameOverScreen")
		var game_over_audio = get_node("../UILayer/GameOverAudio")
		game_over_audio.play()
		get_tree().paused = true
		game_over.visible = true

func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, checkpoint.pos)
		reset_state = false
	if suckingGravities.size() > 0:
		for gravity in suckingGravities:
			var targetVector = _target_vector(gravity)
			state.apply_force(targetVector * 20)
	if Input.is_action_pressed("ui_up") and _frames_since_last_increment >= INCREMENT_INTERVAL:
		state.apply_force(thrust_vector.rotated(rotation))
		_frames_since_last_increment = 0
	if Input.is_action_pressed("ui_up"):
		if isIntenseEngine:
			$IntenseEngineAnimation.visible = true
			$IntenseEngineAnimation.play()
		else:
			$NormalEngineAnimation.visible = true
			$NormalEngineAnimation.play()
	else:
		$NormalEngineAnimation.visible = false
		$NormalEngineAnimation.stop()
		$IntenseEngineAnimation.visible = false
		$IntenseEngineAnimation.stop()

		
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
	print("on spaceship body entered")
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
	inventory.addCoins(item.amount)
	
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
	gunEquipped = gun
	$WeaponSprite.visible = true
	
func use_shield():
	$Shield/ShieldAnimated.visible = true
	$Shield/ShieldCollisionShape.set_deferred("disabled", false)
	$Shield/ShieldTimer.connect("timeout", drop_shield)
	$Shield/ShieldTimer.set_wait_time(10)
	$Shield/ShieldTimer.start()
	
func drop_shield():
	$Shield/ShieldAnimated.visible = false
	$Shield/ShieldCollisionShape.set_deferred("disabled", true)
	
func use_bomb():
	print("bomb used")
	var bullet = bomb.instantiate()
	owner.add_child(bullet)
	bullet.transform = self.global_transform
	$LaserSound.playing = true
	
	
func itemUsed(item):
	match item.idName:
		"LaserGun": equipGun(item.idName)
		"Fish": restore_health(30)
		"Shield": use_shield()
		"Bomb": use_bomb()
		"Shrimp": restore_health(50)
		"Plankton": restore_health(20)
		"Krill": restore_health(10)
		"Speed": use_speed_power_up()
		
func use_speed_power_up():
	thrust_vector =  Vector2(0, -400)
	isIntenseEngine = true
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", on_speed_end)
	timer.set_wait_time(10.0)
	timer.start()
	
func on_speed_end():
	print("speed power up ended")
	thrust_vector =  Vector2(0, -200)
	isIntenseEngine = false

func beSucked(gravity):
	suckingGravities.append(gravity)
	
func stopBeingSucked(gravity):
	suckingGravities.erase(gravity)

func spawnGravitySpiral():
	var randomX = rng.randf_range(20.0, 460.0)
	var randomY = rng.randf_range(20.0, 160.0)
	var spiral = gravitySpiral.instantiate()
	var newTransform = self.global_transform
	newTransform.x = newTransform.x + Vector2(randomX, 0)
	newTransform.x = newTransform.y + Vector2(0, randomY)
	owner.add_child(spiral)
	spiral.transform = newTransform
	setTimerRandom()
	
func setTimerRandom():
	var randomTime = rng.randf_range(100.0, 300.0)
	$Timer.connect("timeout", spawnGravitySpiral)
	$Timer.set_wait_time(randomTime)
	$Timer.start()

func _on_shield_body_entered(body):
	if body.is_in_group("enemy") && !body.is_in_group("boss"):
		body.set_repulsed(true)
		body.get_damage(10)

func _on_shield_body_exited(body):
	if body.is_in_group("enemy") && !body.is_in_group("boss"):
		body.set_repulsed(false)

func _on_shield_area_entered(area):
	if area.is_in_group("bullet"):
		area.queue_free()
