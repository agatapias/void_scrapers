extends Area2D

var isSpaceshipNear = false
var wasSpaceshipNear = false
var spaceship = null
var interacting = false
var interactionAlert

@export var inventory: Inventory
@export var shop: Shop

# buying selling view like Inventory -> Shop

signal merchant

func _ready():
	interactionAlert = get_node('/root/Main/UILayer/InteractionAlert')
	process_mode = Node.PROCESS_MODE_ALWAYS
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isSpaceshipNear and not interacting:
		interactionAlert.visible = true
	elif wasSpaceshipNear and (!isSpaceshipNear or interacting):
		interactionAlert.visible = false
	if (isSpaceshipNear && Input.is_action_just_pressed("interaction")):
		merchant.emit()
		#spaceship.inventory.openView()
		# open shop, pass in player inventory
		interacting = true
		get_tree().paused = true
		shop.openView(spaceship.inventory, inventory)
	if (interacting and Input.is_action_just_pressed("escape")):
		interacting = false
		get_tree().paused = false
		
	wasSpaceshipNear = isSpaceshipNear


func _on_body_entered(body):
	if body.is_in_group("Spaceship"):
		spaceship = body
		isSpaceshipNear = true
		#body.inventory.isSelling = true


func _on_body_exited(body):
	if body.is_in_group("Spaceship"):
		spaceship = null
		isSpaceshipNear = false
		#body.inventory.isSelling = false
