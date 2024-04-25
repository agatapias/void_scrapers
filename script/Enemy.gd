extends RigidBody2D

const MIN_HEALTH = 0
const VISIBILITY_DISTANCE = 500

var health: float = max_health()
var health_bar

func max_health():
	pass

func _ready():
	contact_monitor = true
	max_contacts_reported = 10000
	connect("body_entered", _on_body_entered)
	health_bar = get_node("../EnemyHealthBar")
	health_bar.value = self.health
	health_bar.set_max(max_health())

func _on_body_entered(body: Node):
	pass
			
func set_health(new_health):
	self.health = clamp(new_health, MIN_HEALTH, max_health())
	print(self.health)
	health_bar.value = self.health

func get_damage(damage):
	self.set_health(self.health - damage)
