extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$bgm.play()
	#ResourceLoader.load_threaded_request("res://levels/test stages/stage_1.tscn")
	GlobalScript.restarted_level=false
#	var tween=create_tween()
#	tween.tween_property($ColorRect,"color",Color(255,255,255,0),2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var time=Time.get_datetime_dict_from_system()
	var temp_hour=str(time.hour%12).pad_zeros(2)
	var temp_am_pm
	if time.hour<12:
		temp_am_pm="AM"
	else:temp_am_pm="PM"
	var temp_minute=str(time.minute).pad_zeros(2)
	var temp_second=str(time.second).pad_zeros(2)
	$current_time.text=str("Time: ",time.hour,":",temp_minute,":",temp_second," ",temp_am_pm)
	
func play_sound_when_mouse_over_button():
	$AudioStreamPlayer.play()

func _on_stage_1_pressed():
	#ResourceLoader.load_threaded_get("res://levels/test stages/stage_1.tscn")
	get_tree().change_scene_to_file("res://levels/test stages/stage_1.tscn")
	#GlobalScript.scene_to_be_loaded_index=1


func _on_test_stage_pressed():
	get_tree().change_scene_to_file("res://levels/test stages/test_stage.tscn")
	#GlobalScript.scene_to_be_loaded_index=0


func _on_shadow_man_stage_pressed():
	get_tree().change_scene_to_file("res://levels/test stages/shadow_man_stage_test.tscn")
	#GlobalScript.scene_to_be_loaded_index=2




func _on_test_stage_mouse_entered():
	$AudioStreamPlayer.play()
func _on_stage_1_mouse_entered():
	$AudioStreamPlayer.play()
func _on_shadow_man_stage_mouse_entered():
	$AudioStreamPlayer.play()
func _on_stage_2_mouse_entered():
	$AudioStreamPlayer.play()

func _on_test_boss_stage_pressed():
	get_tree().change_scene_to_file("res://levels/test stages/test_boss_room.tscn")
	#GlobalScript.scene_to_be_loaded_index=3
func _on_stage_2_pressed():
	get_tree().change_scene_to_file('res://levels/test stages/stage_2.tscn')
func _on_stage_3_pressed():
	pass # Replace with function body.
	get_tree().change_scene_to_file('res://levels/test stages/stage_3.tscn')


func _on_stage_4_pressed():
	pass # Replace with function body.
	get_tree().change_scene_to_file('res://levels/test stages/stage_4.tscn')


func _on_bgm_finished():
	pass # Replace with function body.
	$bgm.play()


func _on_input_menu_pressed():
	get_tree().change_scene_to_file('res://levels/input_rebind_menu.tscn')


func _on_test_stage_free_fall_pressed():
	get_tree().change_scene_to_file("res://levels/test stages/stage_test_free_fall.tscn")


func _on_stage_5_pressed():
	get_tree().change_scene_to_file("res://levels/test stages/stage_5_junkman_test.tscn")
