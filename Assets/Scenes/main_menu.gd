extends Control

func _ready():
	
	#hides quit pop up
	$QuitConfirmPopup.visible = false
	

#SinglePlayer Button
func _on_singleplayer_button_pressed() -> void:
	pass # Replace with function body.
	


#Multiplayer Button
func _on_multiplayer_button_pressed() -> void:
	pass # Replace with function body.
	


#Options Button
func _on_options_button_pressed() -> void:
	pass # Replace with function body.


#Quit button
func _on_quit_button_pressed() -> void:
	$QuitConfirmPopup.visible = true
	
#Quit Confirmation Pop Up Buttons
func _on_quit_yes_pressed() -> void:
	get_tree().quit()
	
func _on_quit_no_pressed() -> void:
	$QuitConfirmPopup.visible = false
