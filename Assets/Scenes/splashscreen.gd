extends Node2D

func _ready():
	$Timer.start()
	$Timer2.start()
	$Strawbhillgamestemptransparent/AnimationPlayer.play("new_animation_2")
	
	


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")


func _on_timer_2_timeout() -> void:
	$Strawbhillgamestemptransparent/AnimationPlayer.play("new_animation")
