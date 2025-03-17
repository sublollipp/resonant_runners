extends Node

const GAMESCENE = preload("res://Scenes/main_level_scene.tscn")

var debugPC : int = 1
var offline : bool = true

func start_demo_game(playerCount : int) -> void:
	debugPC = playerCount
	get_tree().change_scene_to_packed(GAMESCENE)
