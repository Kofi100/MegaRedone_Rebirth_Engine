extends CanvasLayer
@onready var progress_bar = $ProgressBar
var selection_index=1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass	
	if selection_index<1:
		selection_index=2
	elif selection_index>2:
		selection_index=1
	progress_bar.value=GlobalScript.health
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused==false:
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

	if selection_index==1:
		$pause_screen_setup/e_tank.play("selected")
	else:
		$pause_screen_setup/e_tank.play("not_selected")
	if selection_index==2:
		$pause_screen_setup/w_tank.play("selected")
	else:
		$pause_screen_setup/w_tank.play("not_selected")
