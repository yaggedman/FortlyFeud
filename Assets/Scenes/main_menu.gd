extends Control

func _ready():
	$AudioStreamPlayer2D.playing = true
	

#SinglePlayer Button
func _on_singleplayer_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/SingleplayerMain.tscn")
	


#Multiplayer Button
func _on_multiplayer_button_pressed() -> void:
	pass # Replace with function body.
	


#Options Button
func _on_options_button_pressed() -> void:
	pass # Replace with function body.


#Quit button
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
