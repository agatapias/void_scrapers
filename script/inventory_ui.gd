extends Control

@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var coinsLabel: Label = $NinePatchRect/CoinAmount
@onready var itemNameLabel: Label = $NinePatchRect/ItemName
@onready var itemDescription: Label = $NinePatchRect/Description
@onready var dropButton: Button = $NinePatchRect/DropButton
@onready var useButton: Button = $NinePatchRect/UseButton

@onready var pause_ui: Control = get_node("../PauseUi")
@onready var shop_ui: Control = get_node("../ShopUi")

var isOpen = false
var selectedSlotIndex = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	connectSlots()
	inventory.update.connect(updateSlots)
	inventory.open.connect(open)
	dropButton.buttonPressed.connect(onDropButtonClicked)
	useButton.buttonPressed.connect(onUseButtonClicked)
	unselect()
	prepareSlots()
	updateSlots()
	close()
	
func _process(delta):
	if Input.is_action_just_pressed("inventory") && pause_ui.visible != true:
		if isOpen: close()
		else: open()
	if Input.is_action_just_pressed("escape"):
		close()
	if Input.is_action_just_pressed("use_bomb"):
		updateSlots()
		var index_of_bomb = inventory.findByName("Bomba")
		# Check if the index is valid
		if index_of_bomb != -1:
			selectedSlotIndex = index_of_bomb
			onUseButtonClicked()
		else:
			print("Object 'Bomb' not found")
		
	
func connectSlots():
	for slot in slots:
		slot.slotSelected.connect(onSlotClicked)

func prepareSlots():
	for i in range(slots.size()):
		slots[i].prepare(i)
	
func updateSlots():
	print("updateSlots called")
	for i in range(slots.size()):   # min(inventory.items.size(), slots.size())
		var isSelected = selectedSlotIndex != null && i == selectedSlotIndex
		slots[i].update(inventory.items[i], isSelected)
	coinsLabel.text = str(inventory.money)
	
func close():
	get_tree().paused = false
	visible = false
	isOpen = false
	
func open():
	unselect()
	shop_ui.close()
	visible = true
	isOpen = true
	get_tree().paused = true
	
func onSlotClicked(item, index):
	if item == null:
		unselect()
	else:
		selectedSlotIndex = index
		itemNameLabel.text = item.name + " - " + str(item.amount) + " złota"
		itemNameLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		itemDescription.text = item.description
	updateSlots()
	
func onDropButtonClicked():
	inventory.removeItem(selectedSlotIndex)
	unselect()
	updateSlots()
	
func onUseButtonClicked():
	inventory.useItem(selectedSlotIndex)
	unselect()
	updateSlots()
	
func unselect():
	selectedSlotIndex = null
	itemNameLabel.text = ""
	itemDescription.text = ""
