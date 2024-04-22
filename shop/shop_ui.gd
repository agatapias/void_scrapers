extends Control

@onready var shop: Shop = preload("res://shop/shop.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var coinsLabel: Label = $NinePatchRect/CoinAmount
@onready var itemNameLabel: Label = $NinePatchRect/ItemName
@onready var charNameLabel: Label = $NinePatchRect/CharName
@onready var dropButton: Button = $NinePatchRect/DropButton
@onready var actionButton: Button = $NinePatchRect/ActionButton
@onready var sellButton: Button = $NinePatchRect/SellButton
@onready var buyButton: Button = $NinePatchRect/BuyButton

var playerInventory: Inventory = null
var merchantInventory: Inventory = null

var isOpen = false
var selectedSlotIndex = null
var state = "Buying"  # "Buying" or "Selling"

var currentInventory = merchantInventory if state == "Buying" else playerInventory

func _ready():
	connectSlots()
	
	var callable1 = Callable(setState)
	
	dropButton.removeItem.connect(onDropButtonClicked)
	actionButton.sellItem.connect(onActionClicked)
	sellButton.sellItem.connect(callable1.bind("Selling"))
	buyButton.sellItem.connect(callable1.bind("Buying"))
	shop.open.connect(open)
	
	prepareSlots()
	close()
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		close()
	
	if selectedSlotIndex != null && dropButton.visible == false:
		dropButton.visible = true
		if actionButton.visible == false:
			actionButton.visible = true	
	elif selectedSlotIndex == null && dropButton.visible == true:
		dropButton.visible = false
		if actionButton.visible == true:
			actionButton.visible = false
	
	if  selectedSlotIndex == null && actionButton.visible == true:
		actionButton.visible = false
		
func prepare(playerInv, merchantInv):
	playerInventory = playerInv
	merchantInventory = merchantInv
	
	buyButton.set_toggle_mode(true)
	buyButton.set_pressed_no_signal(true)
	
	var callable1 = Callable(updateSlots)
	#playerInventory.update.connect(callable1.bind(playerInventory))
	#merchantInventory.update.connect(callable1.bind(merchantInventory))
	
	updateCharName()
	updateSlots(getCurrentInventory())
	
	
func connectSlots():
	for slot in slots:
		slot.slotSelected.connect(onSlotClicked)

func prepareSlots():
	for i in range(slots.size()):
		slots[i].prepare(i)
	
func updateSlots(inv):
	print("updateSlots called, inv")
	print(inv)
	for i in range(slots.size()):
		var isSelected = selectedSlotIndex != null && i == selectedSlotIndex
		slots[i].update(inv.items[i], isSelected)
	coinsLabel.text = str(inv.money)
	
func close():
	visible = false
	isOpen = false
	
func open(pInv, mInv):
	visible = true
	isOpen = true
	prepare(pInv, mInv)
	
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
		
	updateSlots(getCurrentInventory())
	
func onDropButtonClicked():
	print("onDropButtonClicked called")
	getCurrentInventory().removeItem(selectedSlotIndex)
	unselect()
	
func onActionClicked():
	if state == "Buying":
		onBuyCliked()
	else:
		onSellClicked()
	
func onSellClicked():
	var soldItem = playerInventory.sellItem(selectedSlotIndex)
	merchantInventory.buyItem(soldItem)
	unselect()
	updateSlots(getCurrentInventory())
	
func onBuyCliked():
	var soldItem = merchantInventory.sellItem(selectedSlotIndex)
	playerInventory.buyItem(soldItem)
	unselect()
	updateSlots(getCurrentInventory())
	
func setState(value):
	print("setState called, value")
	print(value)
	state = value
	print("state: " + state)
	updateSlots(getCurrentInventory())
	updateCharName()
	
func getCurrentInventory():
	var inv = null
	if state == "Buying":
		actionButton.text = "Kup"
		inv = merchantInventory
	else:
		actionButton.text = "Sprzedaj"
		inv = playerInventory
	return inv
	
func unselect():
	selectedSlotIndex = null
	itemNameLabel.text = ""
	
func updateCharName():
	if state == "Buying":
		charNameLabel.text = "Biznesman"
	else:
		charNameLabel.text = "Ty"
	
