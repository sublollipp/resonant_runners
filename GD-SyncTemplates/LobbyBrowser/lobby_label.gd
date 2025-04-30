extends HBoxContainer

signal join_pressed(lobby_name : String, has_password : bool)

var has_password : bool

func set_lobby_data(data : Dictionary):
	var font = load("res://Assets/Fonts/PixelOperator8.ttf")
	name = data["Name"]
	has_password = data["HasPassword"]
	%LobbyName.text = name
	%LobbyName.add_theme_font_override("font",font)
	%PlayerCount.text = str(data["PlayerCount"])+"/"+str(data["PlayerLimit"])
	%PlayerCount.add_theme_font_override("font",font)
	%PasswordProtected.text = str(has_password).capitalize()
	%PasswordProtected.add_theme_font_override("font",font)
	%Open.text = str(data["Open"]).capitalize()
	%Open.add_theme_font_override("font",font)
	
	%JoinButton.disabled = !data["Open"]
	
	var buttonTheme = load("res://NormalButton.tres")
	%JoinButton.theme = buttonTheme
	
	var tags : Dictionary = data["Tags"]
	if tags.has("Gamemode"): %Gamemode.text = tags["Gamemode"]


func _on_join_button_pressed():
	join_pressed.emit(name, has_password)
