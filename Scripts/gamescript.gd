extends Node2D


const VERSION : String = "1.0.0" # For online-funktionalitet

func _init() -> void:
	GDSync.client_left.connect(death)

func _ready() -> void:
	var player1 : Player = preload("res://Scenes/player.tscn").instantiate()
	GDSync.expose_func(Callable(self, "savescore"))
	player1.position = Vector2(40, -48)
	player1.name = "Player 1"

	$CamController.add_child(player1)
	GDSync.set_gdsync_owner($CamController.get_node("Player 1"), GDSync.lobby_get_all_clients()[0])
	#if ResonantRunners.debugPC > 1:
	if true:
		var player2 : Player = preload("res://Scenes/player.tscn").instantiate()
		player2.position = Vector2(20, -48)
		player2.set_as_player_two()
		player2.name = "Player 2"
		
		$CamController.add_child(player2)
		GDSync.set_gdsync_owner($CamController.get_node("Player 2"), GDSync.lobby_get_all_clients()[1])

func _process(delta: float) -> void:
	if !GDSync.is_host(): return
	$CamController.pos.x += Gamespeed.speed * delta

func switchToGameOver() -> void:
	
	GDSync.change_scene("res://Scenes/UI/game_over.tscn")

func _on_world_boundary_body_entered(body: Node2D) -> void:
	print(str(body.name))
	death()
	print("JDPÅCBCBCVICHGKJFC")

func savescore() -> void:
	if GDSync.is_host():
		var lobbyname : String = GDSync.lobby_get_name()
		var players : Array = GDSync.lobby_get_all_clients()
		if players.size() > 1:
			var player1 = GDSync.player_get_data(players[0], "Username")
			var player2 = GDSync.player_get_data(players[1], "Username")
			ResonantRunners.addScore(lobbyname, player1, player2, int($CamController.position / 100))

func death():
	savescore()
	GDSync.call_func(Callable(self, "savescore"))
		
	Gamespeed.speed = 0
	$SynchronizedAnimationPlayer.play("fadeout")

func _on_left_limit_body_entered(body: Node2D) -> void:
	death()
