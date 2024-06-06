extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$BossWrapper/Enemy.defeated.connect(on_boss_defeated)
	$LevelTransition.visible = false
	$LevelTransition.disable()


func on_boss_defeated(value):
	print("boss defeated collected event")
	$LevelTransition.visible = true
	$LevelTransition.enable()
