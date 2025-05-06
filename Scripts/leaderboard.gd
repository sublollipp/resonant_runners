extends VBoxContainer

@onready var httpnode : HTTPRequest
@onready var highscoreLabelScene : PackedScene = preload("res://Scenes/UI/leadeboard_score.tscn")

func _ready() -> void:
	var htnode : HTTPRequest = HTTPRequest.new()
	htnode.name = "Fetcher"
	add_child(htnode)
	httpnode = get_node("Fetcher")
	getHighScores(10)

func getHighScores(amount : int) -> void:
	httpnode.request_completed.connect(Callable(self, "_on_request_completed"))
	var url = "http://resonantrunnersapi.atwebpages.com/fetchscores.php?scores=" + str(amount)
	var error = httpnode.request(url)
	
	if error != OK:
		print("Request failed to start, error code: ", error)

func _on_request_completed(result, response_code, headers, body : PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	var jsonValid = false
	
	if json is Dictionary:
		# Den json serveren sender har to elementer: "result" (et sorteret array af scores) og "success" (en boolean, der er false hvis der gik noget galt på serveren eller databasen)
		if json["success"]:
			jsonValid = true
		else:
			print("Success er sat til falsk :(")
	
	if !jsonValid:
		print("Fejl!")
	else:
		for i : Dictionary in json["result"]:
			var tempscene : LeaderboardScore = highscoreLabelScene.instantiate()
			tempscene.load_score(i)
			%ScoreList.add_child(tempscene)
			
	print(json)


func _on_button_button_up():
	get_tree().change_scene_to_file("res://Scenes/UI/lobby_browsing_menu.tscn")
