extends Node2D

@onready var speed = Gamespeed.speed;

func _ready() -> void:
	var player1 : Player = preload("res://Scenes/player.tscn").instantiate()
	player1.position = Vector2(40, -48)
	player1.name = "Player 1"
	$CamController.add_child(player1)
	if ResonantRunners.debugPC > 1:
		var player2 : Player = preload("res://Scenes/player.tscn").instantiate()
		player2.position = Vector2(20, -48)
		player2.set_as_player_two()
		player2.name = "Player 2"
		$CamController.add_child(player2)

func _process(delta: float) -> void:
	$CamController.position.x += speed * delta
