extends Area2D

var isSpaceshipNear = false
var interactionAlert
var interacting = false
var wasSpaceshipNear = false
var changed = false
var status = 'new'
var spaceship
var dialog

const quest_name = 'Zaginiona ryba'
const quest_dialog = "Kosmiczny podróżniku! Potrzebuję twojej pomocy - zgubiłem swoją rybę. Proszę pomóż mi ją odnaleźć, a powiem Ci jak uciec z tego przeklętego układu gwiezdnego. Kieruj się ku najbliższej mgławicy drogą pomiędzy asteroidami a znajdziesz Niebieską Planetę. Moja ryba jest w pobliżu. Ale uważaj! Wrogowie czają się za asteroidami. \n\n[Naciśnij K, żeby zaakceptować]\n[Naciśnij R, żeby odrzucić]"
const quest_ongoing = "Nadal czekam na moją rybę! \n\n[Naciśnij K, żeby wyjść]"
const quest_success = "Dziękuję za pomoc! Kieruj się za dziwnymi asteroidami, a znajdziesz drogę do kolejnego układu. Powodzenia! \n\n[Naciśnij K, żeby wyjść]"
const quest_after = "Dzień dobry. \n\n[Naciśnij K, żeby wyjść]"

func _ready():
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
		elif status == 'ongoing' and spaceship.inventory.contains("Fish"):
			_set_dialog(quest_success)
			status = 'finished'
			spaceship.inventory.removeByName('Fish')
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

func _set_dialog(str):
	dialog.visible = true
	dialog.get_child(0).text = str

func _start_interaction():
	interacting = true
	get_tree().paused = true

func _leave_interaction():
	interacting = false
	get_tree().paused = false
	dialog.visible = false
	interactionAlert.visible = false
	changed = false

func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = true

func _on_body_exited(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = false
