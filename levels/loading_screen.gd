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
			get_tree().change_scene_to_file("res://levels/test stages/stage_1.tscn")
		2:
			get_tree().change_scene_to_file('res://levels/test stages/shadow_man_stage_test.tscn')
