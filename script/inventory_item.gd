extends Resource

class_name InventoryItem

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture2D
@export var amount: int = 1
@export var buyingCost: int = 1
@export_enum("Common", "Rare", "Legendary")
var rarity: String = "Common"
