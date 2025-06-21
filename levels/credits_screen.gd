extends Node2D

func _process(delta: float) -> void:
	$RichTextLabel.position.y-=50*delta
	if Input.is_action_just_pressed("die_debug") or Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://levels/beginning_screen.tscn")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	get_tree().change_scene_to_file("res://levels/beginning_screen.tscn")
