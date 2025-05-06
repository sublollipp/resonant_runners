class_name LeaderboardScore extends HBoxContainer

func load_score(score : Dictionary) -> void:
	var date : String = score["date"]
	$DateLabel.text = date.uri_decode()
	$LobbyLabel.text = score["lobby name"].uri_decode()
	$Player1Label.text = score["player 1"].uri_decode()
	$Player2Label.text = score["player 2"].uri_decode()
	$ScoreLabel.text = score["score"].uri_decode()
