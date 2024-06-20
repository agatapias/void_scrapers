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

@onready var pause_ui: Control = get_node("../PauseUi")
@onready var inventory_ui: Control = get_node("../Inventory_UI")

var playerInventory: Inventory = null
var merchantInventory: Inventory = null

var isOpen = false
var selectedSlotIndex = null
var state = "Buying"  # "Buying" or "Selling"

var currentInventory = merchantInventory if state == "Buying" else playerInventory

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	connectSlots()
	
	var callable1 = Callable(setState)
	
	dropButton.buttonPressed.connect(onDropButtonClicked)
	actionButton.buttonPressed.connect(onActionClicked)
	sellButton.buttonPressed.connect(callable1.bind("Selling"))
	buyButton.buttonPressed.connect(callable1.bind("Buying"))
	shop.open.connect(open)
	
	unselect()
	prepareSlots()
	close()
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		close()
	
	if selectedSlotIndex != null && dropButton.visible == false:
		if state == "Selling":
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
		slots[i].update(inv.items[i], inv.item_counts[i], isSelected, true)
	coinsLabel.text = str(inv.money)
	
func close():
	print("shop close called")
	var tree = await get_tree()
	tree.paused = false
	visible = false
	isOpen = false
	
func open(pInv, mInv):
	#inventory_ui.close()
	#get_tree().paused = true
	visible = true
	isOpen = true
	prepare(pInv, mInv)
	
func onSlotClicked(item, index):
	print("onSlotClicked, item:")
	$NinePatchRect/PoorLabel.visible = false
	if item == null:
		print("null")
		selectedSlotIndex = null
		itemNameLabel.text = ""
	else:
		print(item.name)
		$NinePatchRect/CostLabel.visible = true
		$NinePatchRect/ItemCost.text = str(getItemCost(item)) + " złota"
		selectedSlotIndex = index
		#itemNameLabel.text = item.name + " - " + str(item.amount) + " coins"
		$NinePatchRect/Description.text = item.name + " - " + item.description
		itemNameLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
	updateSlots(getCurrentInventory())
	
func onDropButtonClicked():
	print("onDropButtonClicked called")
	getCurrentInventory().removeItem(selectedSlotIndex)
	unselect()
	updateSlots(getCurrentInventory())
	
func onActionClicked():
	print("onActionClicked")
	if state == "Buying":
		onBuyCliked()
	else:
		onSellClicked()
	
func onSellClicked():
	var amount = playerInventory.items[selectedSlotIndex].amount
	var canBuyItem = merchantInventory.canSubtractCoins(amount)
	if !canBuyItem:
		$NinePatchRect/PoorLabel.visible = true
		return
	
	var soldItem = playerInventory.sellItem(selectedSlotIndex, amount)
	merchantInventory.buyItem(soldItem, soldItem.amount)
	unselect()
	updateSlots(getCurrentInventory())
	
func onBuyCliked():
	var cost = merchantInventory.items[selectedSlotIndex].buyingCost
	var canBuyItem = playerInventory.canSubtractCoins(cost)
	if !canBuyItem:
		$NinePatchRect/PoorLabel.visible = true
		return
		
	var soldItem = merchantInventory.sellItem(selectedSlotIndex, cost)
	playerInventory.buyItem(soldItem, cost)
	unselect()
	updateSlots(getCurrentInventory())
	
func setState(value):
	print("setState called, value")
	print(value)
	state = value
	print("state: " + state)
	updateSlots(getCurrentInventory())
	updateShopStateUi()
	
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
	$NinePatchRect/CostLabel.visible = false
	$NinePatchRect/ItemCost.text = ""
	$NinePatchRect/Description.text = ""
	$NinePatchRect/PoorLabel.visible = false
	
func updateShopStateUi():
	unselect()
	updateCharName()
	updateCatMerchant()
	updateDropButton()
	
func updateCharName():
	if state == "Buying":
		charNameLabel.text = "Biznesman"
	else:
		charNameLabel.text = "Ty"
		
func updateCatMerchant():
	if state == "Buying":
		$NinePatchRect/CatImage.visible = true
		$NinePatchRect/CatMessage.visible = true
	else:
		$NinePatchRect/CatImage.visible = false
		$NinePatchRect/CatMessage.visible = false
		
func updateDropButton():
	if state == "Buying":
		dropButton.visible = false
		dropButton.disabled = true
	else:
		dropButton.visible = true
		dropButton.disabled = false
	
func getItemCost(item):
	if state == "Buying":
		return item.buyingCost
	else:
		return item.amount
