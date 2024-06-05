extends Area2D

@onready var dialogUi: Control = get_node("../UILayer/Dialog")

var isSpaceshipNear = false
var interactionAlert
var interacting = false
var wasSpaceshipNear = false
var changed = false
var status = 'new'
var spaceship
var dialog
@export var fishItem: InventoryItem 

const quest_name = 'Kocia Hegemonia'
const quest_dialog = "Jestem Królem Kotów! Czego szukasz w moim systemie!? Przydaj się na coś, a obdaruję Cię skarbami! Kosmici rozleźli się po całym układzie - rozkazuję Ci: zniszcz ich! \n\n[Naciśnij K, żeby zaakceptować]"
const quest_ongoing = "... \n\n[Naciśnij K, żeby wyjść]"
const quest_success = "Dobra robota, włóczęgo. Weź te ryby w nagrodę. \n\n[Naciśnij K, żeby wyjść]"
const quest_after = "Czego chcesz, włóczęgo? \n\n[Naciśnij K, żeby wyjść]"

func _ready():
	$CatKingSprite2D.play()
	interactionAlert = get_node('../UILayer/InteractionAlert')
	dialog = get_node('../UILayer/Dialog')
	spaceship = get_node('../Spaceship')
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if isSpaceshipNear and not interacting:
		interactionAlert.visible = true
	elif wasSpaceshipNear and (!isSpaceshipNear or interacting):
		interactionAlert.visible = false
	if (isSpaceshipNear && Input.is_action_just_pressed("interaction")):
		_start_interaction()

	wasSpaceshipNear = isSpaceshipNear

	if interacting and not changed:
		if status == 'new':
			_set_dialog(quest_dialog)
		elif status == 'ongoing' and _is_quest_fulfilled():
			_set_dialog(quest_success)
			status = 'finished'
			_on_quest_fulfilled()
		elif status == 'ongoing':
			_set_dialog(quest_ongoing)
		else:
			_set_dialog(quest_after)
		changed = true

	if interacting:
		if status == 'new' and Input.is_action_just_pressed("accept"):
			status = 'ongoing'
			_leave_interaction()
		elif status == 'new' and Input.is_action_just_pressed("reject"):
			_leave_interaction()
		elif Input.is_action_just_pressed("accept"):
			_leave_interaction()

func _is_quest_fulfilled():
	var root = get_node("../../Main2")
	var enemies = find_nodes_with_name(root, "Enemy")
	if enemies.is_empty():
		return true
	else:
		return false

func find_nodes_with_name(root_node, name):
	var found_nodes = []
	_find_nodes_recursive(root_node, name, found_nodes)
	return found_nodes

# Helper function to perform the recursive search
func _find_nodes_recursive(node, name, found_nodes):
	if node.name == name:
		found_nodes.append(node)
	for child in node.get_children():
		_find_nodes_recursive(child, name, found_nodes)
	
func _on_quest_fulfilled():
	for i in range(5):
		spaceship.inventory.insert(fishItem)

func _set_dialog(str):
	dialogUi.open()
	dialogUi.setText(str)

func _start_interaction():
	interacting = true
	get_tree().paused = true

func _leave_interaction():
	interacting = false
	get_tree().paused = false
	dialogUi.close()
	dialogUi.setText("")
	interactionAlert.visible = false
	changed = false

func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = true

func _on_body_exited(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = false
