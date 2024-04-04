extends RigidBody2D

const MAX_HEALTH = 200
const MIN_HEALTH = 0

var target_speed = 50.0 # Desired speed in the direction of the target vector
var acceleration_time = 1.0 # Time to reach the target speed
var v0

var target: RigidBody2D

var _health: float = MAX_HEALTH

func _ready():
	contact_monitor = true
	max_contacts_reported = 10000
	#connect("body_entered", _on_body_entered)
	#body_entered.connect(_on_body_entered)

func _target_vector() -> Vector2:
	return position.direction_to(target.position)

func _physics_process(delta):
	if target == null:
		target = get_tree().get_nodes_in_group("Spaceship")[0]
	else:
		if position.distance_to(target.position) > 400:
			return
		
		var targetVector = _target_vector()
		apply_impulse(targetVector)
	
	if _health <= 0:
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "destruction"
	else:
		var acc
		if v0:
			acc  = (linear_velocity  - v0) / delta
		v0 = linear_velocity
		
		if acc and acc > Vector2.ZERO:
			if _health < 70:
				$AnimatedSprite2D.animation = "damaged1"
			elif _health < 50:
				$AnimatedSprite2D.animation = "damaged2"
			else: 
				$AnimatedSprite2D.play()
				$AnimatedSprite2D.animation = "go"
		else:
			$AnimatedSprite2D.stop()
			if _health < 70:
				$AnimatedSprite2D.animation = "damaged1"
			elif _health < 50:
				$AnimatedSprite2D.animation = "damaged2"
			else:
				$AnimatedSprite2D.animation = "default"


func _on_body_entered(body: Node):
	get_damage(10)
	
	if _health <= 0:
		var timer = Timer.new()
		self.add_child(timer)
			
		timer.connect("timeout", queue_free)
		timer.set_wait_time(0.5)
		timer.start()
		
		
func set_health(health):
	_health = clamp(health, MIN_HEALTH, MAX_HEALTH)
	print("enemy health: ", _health)
	#var health_bar = get_node("/root/Main/UILayer/HealthBar")
	#health_bar.value = _health

func get_damage(damage):
	set_health(_health - damage)

