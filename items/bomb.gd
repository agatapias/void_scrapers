extends Area2D

@export var item: InventoryItem

var bodies_in_range = []

func _ready():
	$Explosion.visible = false
	$AnimatedSprite2D.play("default")
	$TickingSound.playing = true
	_start_explosion_timer()


func _start_explosion_timer():
	$Timer.connect("timeout", _explosion)
	$Timer.one_shot = true
	$Timer.wait_time = 4.0
	$Timer.start()


func _explosion():
	$AnimatedSprite2D.play("exploding")
	$TickingSound.playing = false
	

func _on_explosion_body_entered(body):
	if body.is_in_group("enemy") or body.is_in_group("Spaceship"):
		bodies_in_range.append(body)


func _on_explosion_body_exited(body):
	if body.is_in_group("enemy") or body.is_in_group("Spaceship"):
		bodies_in_range.erase(body)


func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.visible = false
	$Explosion.visible = true
	$Explosion/ExplosionAnimation.play()
	$Explosion/ExplosionSound.playing = true
	for body in bodies_in_range:
		body.get_damage(20)


func _on_explosion_animation_animation_finished():
	self.queue_free()
