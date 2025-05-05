extends Node

const GAMESCENE = preload("res://Scenes/main_level_scene.tscn")

var posternode : HTTPRequest

var debugPC : int = 1
var offline : bool = true

func _ready() -> void:
	var hnode : HTTPRequest = HTTPRequest.new()
	hnode.name = "Poster"
	add_child(hnode)
	posternode = get_node("Poster")
	GDSync.expose_func(Callable(self, "addScore"))

func addScore(lobbyName : String, player1 : String, player2 : String, score) -> void:
	
	if lobbyName && player1 && player2:
		posternode.request_completed.connect(Callable(self, "_on_post_completed"))
		var url = "http://resonantrunnersapi.atwebpages.com/postscores.php?lobby=" + lobbyName + "&p1=" + player1 + "&p2=" + player2 + "&score=" + str(score)
		print("URL: ", url)
		var error = posternode.request(url)
		
		if error != OK:
			print("Du kunne ikke tilføje scores af en eller anden årsag: ", error)
	else:
		print("Score for lav")

func start_demo_game(playerCount : int) -> void:
	debugPC = playerCount
	get_tree().change_scene_to_packed(GAMESCENE)
