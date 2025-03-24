extends Node2D

@onready var text_edit = $Control/LineEdit
var username : String
# skal gemmes til spilleren GLOBALS??

func _input(event):
	if event.is_action_pressed("Enter") and text_edit.text != "":
		username = text_edit.text
		get_tree().change_scene_to_file("res://Scenes/UI/lobby.tscn")



func _on_button_button_down():
	if text_edit.text != "":
		username = text_edit.text
		get_tree().change_scene_to_file("res://Scenes/UI/lobby.tscn")
