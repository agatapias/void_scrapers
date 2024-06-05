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

const quest_name = 'Zawzięty kosmita'
const quest_dialog = "Witaj, przybyszu! Zrób mi przysługę, a poradzę Ci jak nie zabić się w tym układzie gwiezdnym. Próbuję wrócić do domu, ale po drugiej stronie planety czai się zwiadowca kosmitów - atakuje wszystko co widzi. Rozwal jego statek! \n\n[Naciśnij K, żeby zaakceptować]\n[Naciśnij R, żeby odrzucić]"
const quest_ongoing = "Kosmita wciąż się czai! \n\n[Naciśnij K, żeby wyjść]"
const quest_success = "Dziękuję za pomoc! Teraz słuchaj - niedaleko stąd znajdziesz gromadę asteroid. A pomiędzy asteroidami pełno złota! Podążaj za szlakiem z monet, a trafisz na miejsce. Problem w tym, że myśliwce kosmitów czają się tam w zasadce. Kup tarcze w pobliskim sklepie, a nie będą w stanie Cię trafić. Tylko uważaj, tarcza chroni Cię tylko przez krótką chwilę. Powodzenia! \n\n[Naciśnij K, żeby wyjść]"
const quest_after = "Czy masz już skarb? \n\n[Naciśnij K, żeby wyjść]"

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
	var target = get_node("../QuestScout")
	if target == null:
		return true
	
func _on_quest_fulfilled():
	pass

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
