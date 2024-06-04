extends Control

const translation_vector = Vector2(-25, -50)
const translation_vector_label = Vector2(-25, -65)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent() != null and get_parent().get_node("Enemy") != null:
		$EnemyHealthBar.position = get_parent().get_node("Enemy").position + translation_vector
		$LifeLabel.position = get_parent().get_node("Enemy").position + translation_vector_label
