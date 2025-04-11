extends CanvasLayer

var playersReady : int = 0

func _init() -> void:
	GDSync.client_left.connect(clientLeft)
	GDSync.disconnected.connect(goToMenu)

func _ready() -> void:
	GDSync.expose_func(addReadyPlayer)

func addReadyPlayer() -> void:
	if GDSync.is_host():
		playersReady += 1
		if playersReady == 2:
			GDSync.change_scene("res://Scenes/main_level_scene.tscn")

func _on_try_again_pressed() -> void:
	addReadyPlayer()
	GDSync.call_func(addReadyPlayer)
	$VBoxContainer/TryAgain.queue_free()

func clientLeft(clientId : int):
	goToMenu()

func goToMenu():
	GDSync.lobby_leave()
	get_tree().change_scene_to_file("res://Scenes/UI/lobby_browsing_menu.tscn")
	print("Nogen gik?")


func _on_leave_pressed() -> void:
	GDSync.lobby_leave()
	get_tree().change_scene_to_file("res://Scenes/UI/lobby_browsing_menu.tscn")
