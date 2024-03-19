extends RigidBody2D

const MAX_HEALTH = 200
const MIN_HEALTH = 0

var target_speed = 50.0 # Desired speed in the direction of the target vector
var acceleration_time = 1.0 # Time to reach the target speed

var target: RigidBody2D

var _health: float = MAX_HEALTH

func _ready():
	connect("body_entered", _on_body_entered)
	#body_entered.connect(_on_body_entered)

func _target_vector() -> Vector2:
	return position.direction_to(target.position)

func _physics_process(delta):
	if target == null:
		target = get_tree().get_nodes_in_group("Spaceship")[0]
	else:
		var targetVector = _target_vector()
		apply_impulse(targetVector)
		
	if linear_velocity > Vector2.ZERO:
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
	print("enemy _on_body_entered called")
	print(body.name)
	get_damage(10)
	
	if _health <= 0:
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "destruction"
		var timer = Timer.new()
		self.add_child(timer)
			
		timer.connect("timeout", queue_free)
		timer.set_wait_time(2)
		timer.start()
		
		
func set_health(health):
	_health = clamp(health, MIN_HEALTH, MAX_HEALTH)
	print("enemy health: ", _health)
	#var health_bar = get_node("/root/Main/UILayer/HealthBar")
	#health_bar.value = _health

func get_damage(damage):
	set_health(_health - damage)

