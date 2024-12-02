extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween_value_effect=create_tween()
	tween_value_effect.tween_property($loading_progress,"value",$loading_progress.max_value,.5)
	tween_value_effect.connect("finished",_on_loading_progress_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_loading_progress_finished():
	match GlobalScript.scene_to_be_loaded_index:
		0:
			get_tree().change_scene_to_file("res://levels/test stages/test_stage.tscn")
		1:
			get_tree().change_scene_to_file("res://levels/test stages/stage_test_free_fall.tscn")
		2:
			get_tree().change_scene_to_file('res://levels/test stages/test_boss_room_2.tscn')
		3:
			get_tree().change_scene_to_file('res://levels/test stages/test_stage_camera_display.tscn')
		4:
			get_tree().change_scene_to_file("res://levels/other_stages/tutorial_stage.tscn")
		5:
			get_tree().change_scene_to_file("res://levels/test stages/stage_1.tscn")
		6:
			get_tree().change_scene_to_file("res://levels/test stages/shadow_man_stage_test.tscn")
		7:
			get_tree().change_scene_to_file("res://levels/test stages/test_boss_room.tscn")
		8:get_tree().change_scene_to_file("res://levels/test stages/stage_2.tscn")
		9:get_tree().change_scene_to_file("res://levels/test stages/stage_3.tscn")
		10:get_tree().change_scene_to_file("res://levels/test stages/stage_4.tscn")
		11:get_tree().change_scene_to_file("res://levels/test stages/stage_5_junkman_test.tscn")
		12:get_tree().change_scene_to_file("res://levels/test stages/bubbleman.tscn")
		13:get_tree().change_scene_to_file("res://levels/test stages/boss_room_3.tscn")
