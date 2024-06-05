extends Control

var translation_vector = Vector2(-25, -50)
var translation_vector_label = Vector2(-25, -65)

func _ready():
	if get_parent().name == "BossWrapper":
		translation_vector = Vector2(-25, -90)
		translation_vector_label = Vector2(-25, -100)

func _process(delta):
	if get_parent() != null and get_parent().get_node("Enemy") != null:
		$EnemyHealthBar.position = get_parent().get_node("Enemy").position + translation_vector
		$LifeLabel.position = get_parent().get_node("Enemy").position + translation_vector_label
