extends Area2D

var isSpaceshipNear = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (isSpaceshipNear && Input.is_action_just_pressed("space")):
		print("inteacting with character")
		# TODO: open dialog or open shop


func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = true


func _on_body_exited(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = false
