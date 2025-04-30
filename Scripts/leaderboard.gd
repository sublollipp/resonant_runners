extends Node

@onready var httpnode : HTTPRequest = HTTPRequest.new()

func getHighScores(amount : int) -> void:
	httpnode.request_completed.connect(_on_request_completed)
	var url = "resonantrunnersapi.wuaze.com/fetchscores.php?scores="
	var error = httpnode.request(url)
	
	if error != OK:
		print("Request failed to start, error code: ", error)

func _on_request_completed(result, response_code, headers, body) -> void:
	var json = JSON.parse_string(body)
	print(result)
	print(response_code)
	print(headers)
	print(json)
