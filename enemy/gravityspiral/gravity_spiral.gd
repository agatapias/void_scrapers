extends Area2D

var rng = RandomNumberGenerator.new()
var currentAnimation = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("appear")
	currentAnimation = "appear"
	_start_death_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		body.beSucked(self)


func _on_body_exited(body):
	if body.is_in_group("Spaceship"):
		body.stopBeingSucked(self)


func _start_death_timer():
	var random = rng.randf_range(2.0, 6.0)
	$Timer.connect("timeout", _kill_node)
	$Timer.one_shot = true
	$Timer.wait_time = random
	$Timer.start()

func _kill_node():
	print("killing gravity spiral")
	currentAnimation = "die"
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("die")

func _on_animated_sprite_2d_animation_finished():
	print("animation finished")
	if currentAnimation == "appear":
		print("playing go")
		$AnimatedSprite2D.play("go")
		currentAnimation == "go"
	elif currentAnimation == "die":
		print("die animation finished, killing spiral")
		queue_free()
