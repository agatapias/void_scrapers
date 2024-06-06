extends Area2D

@onready var interactionAlert: Control = get_node("../UILayer/InteractionAlert")
@onready var dialog: Control = get_node("../UILayer/Dialog")
@onready var spaceship: RigidBody2D = get_node("../Spaceship")

var isSpaceshipNear = false
var interacting = false
var wasSpaceshipNear = false
var changed = false
var status = 'new'

const quest_name = 'Koniec'
const quest_dialog = "Witaj znowu. Jesteś już bardzo blisko końca, ale teraz czeka Cię to co najtrudniejsze. \n\nWłaśnie zleciały się wszystkie maszyny, które mają wykończyć tę planętę. \n\n[Naciśnij K, aby kontynuować]"
const quest_dialog_2 = "Jeżeli uda Ci się ich pokonać, może zdążysz jeszcze uciec z tego przeklętego miejsca. \n\nSłyszałem, że w okolicy otworzył się sklep. Niektórzy nie wiedzą co to rozsądek... \n\n[Naciśnij K, żeby kontynuować]"
const quest_ongoing = "Lepiej już idź. Im dłużej tu jesteś, tym mniejsze szanse, że przeżyjesz. \n\n[Naciśnij K, żeby wyjść]"

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Animation.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		elif status == 'ongoing':
			_set_dialog(quest_ongoing)
		changed = true

	if interacting and Input.is_action_just_pressed("accept"):
		if status == 'new':
			status = '2'
			_set_dialog(quest_dialog_2)
		elif status == '2':
			status = 'ongoing'
		elif status == 'ongoing':
			_leave_interaction()
	elif interacting and status == 'ongoing' and Input.is_action_just_pressed("accept"):
		_leave_interaction()
	elif Input.is_action_just_pressed("reject"):
		_leave_interaction()


func _set_dialog(str):
	dialog.open()
	dialog.setText(str)

func _start_interaction():
	interacting = true
	get_tree().paused = true

func _leave_interaction():
	interacting = false
	get_tree().paused = false
	dialog.close()
	dialog.setText("")
	interactionAlert.visible = false
	changed = false

func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = true

func _on_body_exited(body):
	if body.is_in_group("Spaceship"):
		isSpaceshipNear = false
