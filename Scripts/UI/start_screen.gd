extends Node2D

@onready var info_label = $InfoLabel


var labelOpacity: float = 1.0
var labelOpacityIncrement: float = -0.5  # Speed of fade effect

func _process(delta):
	pulse(delta)  # Smooth transition
	info_label.set("theme_override_colors/font_color", Color(0, 0, 0, labelOpacity))

func pulse(delta):
	labelOpacity += labelOpacityIncrement * delta
	if labelOpacity >= 1.0:  
		labelOpacity = 1.0
		labelOpacityIncrement *= -1
	elif labelOpacity <= 0.4:  
		labelOpacity = 0.4
		labelOpacityIncrement *= -1
		
func _input(event):
	if (event is InputEventKey and event.is_pressed()) or event.is_action_pressed("MousePressed"):
		get_tree().change_scene_to_file("res://Scenes/UI/enter_username.tscn")
