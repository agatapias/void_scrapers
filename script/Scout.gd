extends "res://script/Enemy.gd"

const MAX_HEALTH = 50

var target_speed = 50.0 # Desired speed in the direction of the target vector
var acceleration_time = 1.0 # Time to reach the target speed
var v0
var state = "idle"
var currentAnimation = ""

@export var coin: PackedScene
var target: RigidBody2D
var rng = RandomNumberGenerator.new()

func _target_vector() -> Vector2:
	return position.direction_to(target.position)

func _on_body_entered(body: Node):
	get_damage(10)

func _physics_process(delta):
	if target == null:
		target = get_tree().get_first_node_in_group("Spaceship")
	else:
		_process_state()
		if state == "hostile":
			_process_acc()
		
	_process_animation(delta)
	
func _process_animation(delta):
	if health <= 0:
		$Sprite2D.visible = false
		currentAnimation = "destruction"
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "destruction"

	else:
		var acc
		if v0:
			acc  = (linear_velocity  - v0) / delta
		v0 = linear_velocity
		
		if acc and acc.abs() != Vector2.ZERO:
			if health < 70:
				$AnimatedSprite2D.animation = "damaged1"
			elif health < 50:
				$AnimatedSprite2D.animation = "damaged2"
			else: 
				$AnimatedSprite2D.play()
				$AnimatedSprite2D.animation = "go"
				if not $EngineAudio.playing:
					$EngineAudio.playing = true
		else:
			$AnimatedSprite2D.stop()
			if health < 70:
				$AnimatedSprite2D.animation = "damaged1"
			elif health < 50:
				$AnimatedSprite2D.animation = "damaged2"
			else:
				$AnimatedSprite2D.animation = "default"
				$EngineAudio.playing = false

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
	print("scout max health called")
	return MAX_HEALTH


func _on_animated_sprite_2d_animation_finished():
	if currentAnimation == "destruction":
		die()


func die():
	self.visible = false
	drop_many_coins()
	get_parent().queue_free()

func drop_many_coins():
	var rand = rng.randi_range(2,7)
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
