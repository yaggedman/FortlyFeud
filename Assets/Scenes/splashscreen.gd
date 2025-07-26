extends Control

func _ready():
	$Timer.start()
	$Timer2.start()
	$Control/AnimatedSprite2D.play("default")
	
	


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")


func _on_timer_2_timeout() -> void:
	$Control/AnimatedSprite2D/AnimationPlayer.play("fadetoblack")
	
	



func _on_skipmenubutton_pressed() -> void:
	print("button pressed!")
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
