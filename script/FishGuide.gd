extends Area2D

var velocity = Vector2(0, 0)  
const MAX_Y = -5000

func start():
	velocity = Vector2(0, -30)  
	$AnimatedSprite2D.animation = "go"
	$AnimatedSprite2D.play()

func _ready():
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()

func _process(delta):
	global_position += velocity * delta
	
	if global_position.y < MAX_Y:
		velocity = Vector2(0, 0)  
