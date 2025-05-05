class_name LeaderboardScore extends HBoxContainer

func load_score(score : Dictionary) -> void:
	var date : String = score["date"]
	$DateLabel.text = date
	$LobbyLabel.text = score["lobby name"]
	$Player1Label.text = score["player 1"]
	$Player2Label.text = score["player 2"]
	$ScoreLabel.text = score["score"]
