extends CanvasLayer
@onready var health_bar = $healthbar
var selection_index=1;
##This boolean pauses all inputs to the HUD for some effects.
var pause_input=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$pause_screen_setup/ProgressBar.value=GlobalScript.health
	health_bar.value=GlobalScript.health;health_bar.max_value=GlobalScript.max_health
	$pause_screen_setup/ProgressBar.max_value=GlobalScript.max_health
	$pause_screen_setup/e_tank_left.text=str(GlobalScript.energy_tank_no)
	
	
	if selection_index<1:
		selection_index=2
	elif selection_index>2:
		selection_index=1
	if !pause_input:#if input is not paused yet,
		if Input.is_action_just_pressed("pause"):#and i pressed the pause button,
			if get_tree().paused==false:#if the tree is paused/not,set it to the opposite state
				get_tree().paused=true
				$pause_menu_sound.play()
			elif get_tree().paused==true:
				get_tree().paused=false
	if get_tree().paused:
		$pause_screen_setup.visible=true
	else:
		$pause_screen_setup.visible=false
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
					if GlobalScript.health<=GlobalScript.max_health/2:
						tween.tween_property($pause_screen_setup/ProgressBar,"value",GlobalScript.max_health,2)
					elif GlobalScript.health>GlobalScript.max_health/2:
						tween.tween_property($pause_screen_setup/ProgressBar,"value",GlobalScript.max_health,0.5)
					pause_input=true
					#if tween.
		else:
			$pause_screen_setup/e_tank.play("not_selected")
		if selection_index==2:
			$pause_screen_setup/w_tank.play("selected")
		else:
			$pause_screen_setup/w_tank.play("not_selected")

func tween_finished():
	GlobalScript.health=GlobalScript.max_health
	pause_input=false
	print('tween finished')
	
