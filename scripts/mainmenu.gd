extends Control

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_option_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
