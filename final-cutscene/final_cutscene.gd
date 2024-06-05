extends Node2D

signal transition

func _ready():
	$AnimationPlayer.play("new_animation")
	$SpaceshipStatic/AnimatedSprite2D.play("go")
	$AudioStreamPlayer.playing = true


func _on_restart_pressed():
	print("open menu called")
	var data = {level = "start_menu.tscn", level_node = "Menu", items = [], health = 100}
	transition.emit(data)
