extends Control

@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var coinsLabel: Label = $NinePatchRect/CoinAmount
@onready var itemNameLabel: Label = $NinePatchRect/ItemName
@onready var dropButton: Button = $NinePatchRect/DropButton
@onready var actionButton: Button = $NinePatchRect/ActionButton

var isOpen = false
var selectedSlotIndex = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	connectSlots()
	inventory.update.connect(updateSlots)
	inventory.open.connect(open)
	dropButton.removeItem.connect(onDropButtonClicked)
	actionButton.sellItem.connect(onSellClicked)
	prepareSlots()
	updateSlots()
	close()
	
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if isOpen: close()
		else: open()
	if Input.is_action_just_pressed("escape"):
		close()
	
	if selectedSlotIndex != null && dropButton.visible == false:
		dropButton.visible = true
		if inventory.isSelling && actionButton.visible == false:
			actionButton.visible = true	
	elif selectedSlotIndex == null && dropButton.visible == true:
		dropButton.visible = false
		if inventory.isSelling && actionButton.visible == true:
			actionButton.visible = false
	
	if !inventory.isSelling && actionButton.visible == true:
		actionButton.visible = false
	
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
	visible = false
	isOpen = false
	
func open():
	visible = true
	isOpen = true
	
func onSlotClicked(item, index):
	print("onSlotClicked, item:")
	if item == null:
		print("null")
		selectedSlotIndex = null
		itemNameLabel.text = ""
	else:
		print(item.name)
		#var index = inventory.items.find(item)
		#print("found index: " + str(index))
		selectedSlotIndex = index
		itemNameLabel.text = item.name + " - " + str(item.amount) + " coins"
		itemNameLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	updateSlots()
	
func onDropButtonClicked():
	print("onDropButtonClicked called")
	inventory.removeItem(selectedSlotIndex)
	selectedSlotIndex = null
	
func onSellClicked():
	print("onSellClicked called")
	inventory.sellItem(selectedSlotIndex)
	selectedSlotIndex = null
	
