extends Node

@export var scenes = {
		
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		remove_child(child)
	var scene = scenes['Menu'].instantiate()
	add_child(scene)
	$StartMenu.transition.connect(callback)

func callback(data):
	for child in get_children():
		remove_child(child)
	print(data['level_node'])
	var scene = scenes[data.level_node].instantiate()
	add_child(scene)
	var spaceship = scene.get_node('Spaceship')
	if data.health != null:
		spaceship._health = data.health
	if data.items != null:
		spaceship.inventory.items = data.items
	var node = scene.get_node("LevelTransition")
	if node != null:
		node.transition.connect(callback)
	print('done')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
