extends Control

func _on_single_player_button_pressed() -> void:
	ResonantRunners.start_demo_game(1)

func _on_two_player_button_pressed() -> void:
	ResonantRunners.start_demo_game(2)
