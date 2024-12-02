extends Node2D

var score_transfer:int=0
# Called when the node enters the scene tree for the first time.
func _ready():
	var tween=create_tween()
	tween.tween_property(self,"score_transfer",GlobalScript.score,1)
	tween.connect("finished",start_Score_label_timer)
var accept_input_to_change_Scene:bool=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$score_label.text=str("Score:",score_transfer).pad_zeros(3)
	if accept_input_to_change_Scene==true:
		if Input.is_action_just_pressed("pause"):
			get_tree().change_scene_to_file("res://levels/main_menu.tscn")


func start_Score_label_timer():
	#$score_label/Timer.start()
	accept_input_to_change_Scene=true
	$press_continue_label/AnimationPlayer.play("blink")
	$effect.play()


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")


func _on_level_ended_bgm_finished():
	#$level_ended_bgm.play()
	pass
