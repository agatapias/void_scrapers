extends Control

@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var coinsLabel: Label = $NinePatchRect/CoinAmount

var isOpen = false

func _ready():
	inventory.update.connect(updateSlots)
	updateSlots()
	close()
	
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if isOpen:
			close()
		else:
			open()
	

func updateSlots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])
	coinsLabel.text = str(inventory.money)
	
func close():
	visible = false
	isOpen = false
	
func open():
	visible = true
	isOpen = true
