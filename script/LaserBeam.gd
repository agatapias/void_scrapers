extends Area2D

var target
var body_inside = false
var damage_rate = 20

func _ready():
	$LaserAnimatedSprite2D.animation = "default"
	$LaserAnimatedSprite2D.play()
	
func _process(delta):
	if not $LaserSound.playing and self.visible:
		$LaserSound.play(0.0)
	if not self.visible:
		$LaserSound.playing = false
		
	if target == null:
		target = get_tree().get_nodes_in_group("Spaceship")[0]
	if body_inside and self.visible:
		target.get_damage(20*delta)
		
func _on_body_entered(body: Node):
	if body == target:
		body_inside = true

func _on_body_exited(body: Node):
	if body == target:
		body_inside = false 
		
func _on_laser_sound_finished():
	if self.visible:
		$LaserSound.play(0.0)
