extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$main_menu_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	#get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	$pressOrConfirmButtonSound.play()
	$screen1.visible=false
	$screen2.visible=true


func _on_quit_pressed():
	$ConfirmationDialog.show()
	$pressOrConfirmButtonSound.play()


func _on_confirmation_dialog_confirmed():
	get_tree().quit(0)
	print("QUITTING GAME")


func _on_main_menu_music_finished():
	$main_menu_music.play()


func _on_play_pressed():
	$pressOrConfirmButtonSound.play()
	await $pressOrConfirmButtonSound.finished
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	if $screen2/ScrollContainer/VBoxContainer/screenTwoPlayBtn.is_inside_tree():
		pass


func _on_ok_pressed():
	pass # Replace with function body.
	$credits.visible=false
	$screen2.visible=true
	$pressOrConfirmButtonSound.play()


func _on_credits_pressed(): 
	$pressOrConfirmButtonSound.play()
	await $pressOrConfirmButtonSound.finished
	var creditsScene:PackedScene=preload("res://levels/credits_screen.tscn")
	#$credits.visible=true
	#$screen2.visible=false
	get_tree().change_scene_to_packed(creditsScene)
	
	


func _on_exit_pressed():
	$ConfirmationDialog.show()
	$pressOrConfirmButtonSound.play()



func _on_screen_one_continue_btn_mouse_entered():
	$hoverButtonSound.play()

func _on_screen_one_quit_btn_mouse_entered():
	$hoverButtonSound.play()

func _on_screen_two_credits_btn_mouse_entered():
	$hoverButtonSound.play()

func _on_screen_two_play_btn_mouse_entered():
	$hoverButtonSound.play()

func _on_screen_two_exit_btn_mouse_entered():
	$hoverButtonSound.play()

func _on_screen_credits_ok_btn_mouse_entered():
	$hoverButtonSound.play()


func _on_start_animation_player_timer_timeout():
	$AnimationPlayer.play("start")
