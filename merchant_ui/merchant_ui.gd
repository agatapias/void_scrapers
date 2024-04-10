extends Control

@onready var playerInventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var merchantInventory: Inventory = preload("res://inventory/cat_merchant_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var playerCoinsLabel: Label = $NinePatchRect/PlayerCoins
@onready var merchantCoinsLabel: Label = $NinePatchRect/MerchantCoins
@onready var dropButton: Button = $NinePatchRect/DropButton
@onready var actionButton: Button = $NinePatchRect/ActionButton
@onready var buyVariantButton: Button = $NinePatchRect/BuyVariantButton
@onready var sellVariantButton: Button = $NinePatchRect/SellVariantButton

var isOpen = false
var selectedSlotIndex = null
var viewType = "merchant"  # "player" or "merchant"
#
#func _ready():
	#connectSlots()
	#inventory.update.connect(updateSlots)
	#dropButton.removeItem.connect(onDropButtonClicked)
	#updateSlots()
	#close()
	#
#func _process(delta):
	#if Input.is_action_just_pressed("inventory"):
		#if isOpen: close()
		#else: open()
	#if selectedSlotIndex != null && dropButton.visible == false:
		#dropButton.visible = true
	#elif selectedSlotIndex == null && dropButton.visible == true:
		#dropButton.visible = false
	#
#func connectSlots():
	#for slot in slots:
		#slot.slotSelected.connect(onSlotClicked)
#
#func updateSlots():
	#for i in range(min(inventory.items.size(), slots.size())):
		#slots[i].update(inventory.items[i])
	#coinsLabel.text = str(inventory.money)
	#
#func close():
	#visible = false
	#isOpen = false
	#
#func open():
	#visible = true
	#isOpen = true
	#
#func onSlotClicked(item):
	#if item == null:
		#selectedSlotIndex = null
	#else:
		#var index = inventory.items.find(item)
		#selectedSlotIndex = index
	#
#func onDropButtonClicked():
	#inventory.removeItem(selectedSlotIndex)
	#selectedSlotIndex = null
