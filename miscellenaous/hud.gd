extends CanvasLayer
@onready var health_bar = $healthbar
@export_category('timer')
@onready  var minutes = $timer/minutes
@onready var seconds = $timer/seconds
@onready var millsecs = $timer/millsecs

var selection_index=1;#var tween=create_tween() #use tween to create a transiton effect for increasing the health of the player
##This boolean pauses all inputs to the HUD for some effects.
var pause_input=false;var color
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	color=$fade_out_rectangle.color
	print(color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#round()
	minutes.text=str(GlobalScript.minute_level)
	seconds.text=str(int(GlobalScript.second_level))
	millsecs.text=str(int(GlobalScript.milliseconds))
	#millsecs=int()
	#$pause_screen_setup/ConfirmationDialog.global_position=Vector2(500,500)
	#print($map.get_size())
	$pause_screen_setup/ProgressBar.value=GlobalScript.health
	health_bar.value=GlobalScript.health;health_bar.max_value=GlobalScript.max_health
	$pause_screen_setup/ProgressBar.max_value=GlobalScript.max_health
	$pause_screen_setup/e_tank_left.text=str(GlobalScript.energy_tank_no)
	weapon_energy_update()
	if GlobalScript.health<=0:
		
		if $fade_out_effect/AnimationPlayer.current_animation!='fade_out':
			#$fade_out_effect.visible=true
			$fade_out_effect/AnimationPlayer.play("fade_out")
	if get_tree().paused:
		$map.visible=false
		GlobalScript.pause_level_timer()
		$timer/seconds_timer.set_timer_process_callback(false)
	else:
		$map.visible=true
		GlobalScript.start_level_timer()
		$timer/seconds_timer.set_timer_process_callback(true)
	
	if selection_index<1:
		selection_index=2
	elif selection_index>2:
		selection_index=1
	if !pause_input:#if input is not paused yet,
		if Input.is_action_just_pressed("pause"):#and i pressed the pause button,
			if get_tree().paused==false:#if the tree is paused/not,set it to the opposite state
				get_tree().paused=true
				$pause_menu_sound.play()
				var fade_in_tween=create_tween()#this creates a tween which creates a dim effect for the pause screen
				fade_in_tween.tween_property($fade_out_rectangle,"color",Color(0,0,0,0),.2)
			elif get_tree().paused==true:
				get_tree().paused=false
	if get_tree().paused:
		$pause_screen_setup.visible=true
		
		$fade_out_rectangle.visible=true
	else:
		$pause_screen_setup.visible=false
		$fade_out_rectangle.visible=false
		$fade_out_rectangle.color=color
	if get_tree().paused:
		
		if Input.is_action_just_pressed("move_left"):
			selection_index-=1
			$switch_menu_option_sound.play(0)
		elif Input.is_action_just_pressed("move_right"):
			selection_index+=1
			$switch_menu_option_sound.play(0)
	else:
		selection_index=1
	if get_tree().paused:
		if selection_index==1: #energy tank selected
			$pause_screen_setup/e_tank.play("selected")
			if Input.is_action_just_pressed("shoot") and GlobalScript.health<GlobalScript.max_health:#shoot pressed,health<max_health
				if GlobalScript.energy_tank_no>0:#if energy tank no>0,
					GlobalScript.energy_tank_no-=1#deduct by 1
					
					var tween=create_tween() #use tween to create a transiton effect for increasing the health of the player
					tween.connect("finished",tween_finished)
					if float(GlobalScript.health<=GlobalScript.max_health/2):
						tween.tween_property($pause_screen_setup/ProgressBar,"value",GlobalScript.max_health,2)
					elif float(GlobalScript.health>GlobalScript.max_health/2):
						tween.tween_property($pause_screen_setup/ProgressBar,"value",GlobalScript.max_health,0.5)
					pause_input=true
					#if tween.
		else:
			$pause_screen_setup/e_tank.play("not_selected")
		if selection_index==2:
			$pause_screen_setup/w_tank.play("selected")
		else:
			$pause_screen_setup/w_tank.play("not_selected")
	#print($pause_screen_setup/ProgressBar.value,previous_value)
func tween_finished():
	GlobalScript.health=GlobalScript.max_health
	pause_input=false
	print('tween finished')
	

#var previous_value=0
func _on_progress_bar_value_changed(value):#if the value of the bar changes
	#previous_value=value
#	if value<GlobalScript.previous_health:
	if GlobalScript.previous_health<value:# and it's value>prev.health,
		if not $increase_health.playing:#if the sound is not playing
			$increase_health.play(0)#play it
#		#if tween.is_running():
#			$increase_health.play(0)

func weapon_energy_update():
	if GlobalScript.weapon_number!=0:
		$weapon_energy.visible=true
	else:
		$weapon_energy.visible=false
	
	match GlobalScript.weapon_number:
		1:  $weapon_energy.set_modulate(Color(255,4,28,255));$weapon_energy.value=MegamanAndItems.weapon1energy
		2:  $weapon_energy.set_modulate(Color(255,4,28,255));$weapon_energy.value=MegamanAndItems.weapon2energy
	
	update_energy_pause_menu()

func update_energy_pause_menu():
	$pause_screen_setup/weapons/mm_buster/ProgressBar.ratio=1
	$pause_screen_setup/weapons/rush_coil/ProgressBar.value=MegamanAndItems.weapon1energy;$pause_screen_setup/weapons/rush_coil/ProgressBar.max_value=30
	$pause_screen_setup/weapons/rush_jet/ProgressBar.value=MegamanAndItems.weapon2energy;$pause_screen_setup/weapons/rush_jet/ProgressBar.max_value=30


func _on_quit_button_pressed():
	get_tree().quit(0)


func _on_go_to_menu_btn_pressed():
	$pause_screen_setup/ConfirmationDialog.show()


func _on_confirmation_dialog_confirmed():
	get_tree().change_scene_to_file('res://levels/main_menu.tscn')
	get_tree().paused=false


func _on_confirmation_dialog_canceled():
	$pause_screen_setup/ConfirmationDialog.hide()


func _on_seconds_timer_timeout():
	#GlobalScript.second_level+=1
	pass
