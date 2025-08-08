extends Control

func _ready():
	$AudioStreamPlayer2D.playing = true
	

#SinglePlayer Button
func _on_singleplayer_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/SingleplayerMain.tscn")
	


#Multiplayer Button
func _on_multiplayer_button_pressed() -> void:
	pass # Replace with function body.
	var game_scene = preload("res://Assets/Scenes/SingleplayerMain.tscn")
	var game_instance = game_scene.instantiate()
	game_instance.is_multiplayer = true
	
	call_deferred("_switch_scene", game_instance)
	
func _switch_scene(new_scene):
	var current_scene = get_tree().current_scene
	
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene.queue_free()
	


#Options Button
func _on_options_button_pressed() -> void:
	pass # Replace with function body.


#Quit button
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
