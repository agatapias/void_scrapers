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
const fish_target = 5
var guide

const quest_name = 'Głodny piesek'
var quest_dialog = ("Halo! Tak, do Ciebie mówię! Mój piesek jest głodny, nie masz może jakiejś rybki? Hmm...? Chcesz coś w zamian, co? Zróbmy tak: przynieś mi z " + str(fish_target) + " ryb, a pokażę Ci jak dostać się na skraj galaktyki. Co ty na to? \n\n[Naciśnij K, żeby zaakceptować]\n[Naciśnij R, żeby odrzucić]")
const quest_ongoing = "Ryby ukrywają się w całym układzie, musisz się tylko rozejrzeć. Możesz też spróbować u Króla Kotów - o ile masz odwagę. \n\n[Naciśnij K, żeby wyjść]"
const quest_success = "Dziękuję za pomoc! Mój pies będzie bardzo szczęsliwy. Leć za moją ośmiornicą a trafisz do swojego celu. Ostrożnej drogi! \n\n[Naciśnij K, żeby wyjść]"
const quest_after = "Co tu jeszcze robisz, co? \n\n[Naciśnij K, żeby wyjść]"

func _ready():
	interactionAlert = get_node('../UILayer/InteractionAlert')
	dialog = get_node('../UILayer/Dialog')
	spaceship = get_node('../Spaceship')
	process_mode = Node.PROCESS_MODE_ALWAYS
	guide = get_node('../FishGuide')

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
	return spaceship.inventory.containsN("Ryber", fish_target)
	
func _on_quest_fulfilled():
	for i in range(fish_target):
		spaceship.inventory.removeByName("Ryber")
	guide.visible = true
	guide.start()

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
