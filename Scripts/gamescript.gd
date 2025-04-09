extends Node2D

@onready var speed = Gamespeed.speed;

const VERSION : String = "1.0.0" # For online-funktionalitet

func _ready() -> void:
	var player1 : Player = preload("res://Scenes/player.tscn").instantiate()
	player1.position = Vector2(40, -48)
	player1.name = "Player 1"


	$CamController.add_child(player1)
	GDSync.set_gdsync_owner($CamController.get_node("Player 1"), GDSync.lobby_get_all_clients()[0])
	if ResonantRunners.debugPC > 1:
		var player2 : Player = preload("res://Scenes/player.tscn").instantiate()
		player2.position = Vector2(20, -48)
		player2.set_as_player_two()
		player2.name = "Player 2"
		
		$CamController.add_child(player2)
		GDSync.set_gdsync_owner($CamController.get_node("Player 2"), GDSync.lobby_get_all_clients()[1])

func _process(delta: float) -> void:
	if !GDSync.is_host(): return
	$CamController.position.x += speed * delta
