extends CanvasLayer

class_name ui
signal game_started

@onready var end_of_game_screen = $RespawnControl/end_of_game_screen

func _ready():
	end_of_game_screen.visible = false

func on_game_over():
	end_of_game_screen.visible = true
	
func _on_respawn_button_pressed():
	get_tree().reload_current_scene() #needs to be changed to ignore cutscene
	Global.player_health = Global.max_player_health

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	Global.player_health = Global.max_player_health



