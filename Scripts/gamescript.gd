extends Node2D

@onready var speed = Gamespeed.speed;

const VERSION : String = "1.0.0" # For online-funktionalitet

func _ready() -> void:
	var player1 : Player = preload("res://Scenes/player.tscn").instantiate()
	player1.position = Vector2(40, -48)
	player1.name = "Player 1"
	player1.get_node("ColorRect").color = Color(Color.CYAN, 0.3) # 0.3 gør den gennemsigtig
	player1.get_node("ColorRect").show()
	$CamController.add_child(player1)
	if ResonantRunners.debugPC > 1:
		var player2 : Player = preload("res://Scenes/player.tscn").instantiate()
		player2.position = Vector2(20, -48)
		player2.set_as_player_two()
		player2.name = "Player 2"
		player2.get_node("ColorRect").color = Color(Color.ORANGE, 0.3) # 0.3 gør den gennemsigtig
		player2.get_node("ColorRect").show()
		$CamController.add_child(player2)

func _process(delta: float) -> void:
	$CamController.position.x += speed * delta
