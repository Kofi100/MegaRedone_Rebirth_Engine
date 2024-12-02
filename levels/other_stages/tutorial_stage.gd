extends Node2D
@onready var instructions_1 = $all_text/instructions_1
@onready var instructions_2 = $all_text/instructions_2


# Called when the node enters the scene tree for the first time.
func _ready():
	array_of_inputs_keys.resize(10)
	$bgm.play()

var array_of_inputs_keys:Array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	StageFunctions.loop_music($bgm,0,251)
	#print(InputMap.action_get_events("move_left"))
	for i in InputMap.action_get_events("move_left"):
		for j in InputMap.action_get_events("move_right"):
			if i is InputEventKey and j is InputEventKey:
				#print(i.get_physical_keycode())
				#print(OS.get_keycode_string(i.keycode))
				#var inputevent_left=InputEventKey
				array_of_inputs_keys[0]=OS.get_keycode_string(i.get_physical_keycode())
				array_of_inputs_keys[1]=OS.get_keycode_string(j.get_physical_keycode())
				#print(i.keycode)
				$all_text/arrow_1/left_label.text=str("Key:"+array_of_inputs_keys[0])
				$all_text/arrow_2/right_label.text=str("Key:"+array_of_inputs_keys[1])
				#instructions_1.text="PRESS "+str(array_of_inputs_keys[0])+" TO MOVE LEFT\n"+"press "+str(array_of_inputs_keys[1])+" TO MOVE RIGHT"
	for keys in InputMap.action_get_events("jump"):
		for keys2 in InputMap.action_get_events("dash"):
			if keys is InputEventKey and keys2 is InputEventKey:
				array_of_inputs_keys[2]=OS.get_keycode_string(keys.get_physical_keycode())
				#if keys2.PHYSICAL==true:
				#print(name,"-> InputMap: Dash:get_physical_keycode():",keys2.get_physical_keycode())#keys2.PHYSICAL)
				if keys2.get_physical_keycode()!=0:
					array_of_inputs_keys[3]=OS.get_keycode_string(keys2.get_physical_keycode())
				else:
					array_of_inputs_keys[3]=OS.get_keycode_string(keys2.get_keycode())
				#instructions_2.text="PRESS "+str(array_of_inputs_keys[2])+" TO JUMP AND\n"+"press "+str(array_of_inputs_keys[3])+" TO SHOOT AND CHARGE YOUR BUSTER."
				$all_text/JumpPreview/label.text=str("Key:"+array_of_inputs_keys[2])
				$all_text/DashPreview/label.text=str("Key:"+array_of_inputs_keys[3])
				#print(keys2)
				
	for keys_shoot in InputMap.action_get_events("shoot"):
		if keys_shoot is InputEventKey:
			if keys_shoot.get_physical_keycode()!=0:
				array_of_inputs_keys[4]=OS.get_keycode_string(keys_shoot.get_physical_keycode())
			else:
				array_of_inputs_keys[4]=OS.get_keycode_string(keys_shoot.get_keycode())
			
			$all_text2/shoot.text=str("Press,Hold and \n Release Key:"+array_of_inputs_keys[4]+"\n on the keyboard \nIn order to shoot different \nvarieties of chargeshots")
			$all_text4/enemy_shoot.text=str("Try using the >>",str(array_of_inputs_keys[4]),"<< key \nto shoot at the enemy \non this screen")
	for keys_up in InputMap.action_get_events("move_up"):
		for keys_down in InputMap.action_get_events("move_down"):
			if keys_up is InputEventKey and keys_down is InputEventKey:
				#return
				if keys_up.get_physical_keycode()!=0:
					array_of_inputs_keys[5]=OS.get_keycode_string(keys_up.get_physical_keycode())
				else:
					array_of_inputs_keys[5]=OS.get_keycode_string(keys_up.get_keycode())
				if keys_down.get_physical_keycode()!=0:
					array_of_inputs_keys[6]=OS.get_keycode_string(keys_down.get_physical_keycode())
				else:
					array_of_inputs_keys[6]=OS.get_keycode_string(keys_down.get_keycode())
			$all_text3/climb.text=str("Press Key:",str(array_of_inputs_keys[5]),"\n around the ladder to move up\n,and press Key: ",str(array_of_inputs_keys[6]),"\nto move down the ladder")
	#for keys_weap_l in InputMap.action_get_events("switch_weapon_left")
	pick_up_current_key_binding("switch_weapon_left",null,7)
	pick_up_current_key_binding("switch_weapon_right",null,8)
	$all_text5/text_switch_weapons.text=str("\nuse Key:> ",str(array_of_inputs_keys[7])," <to switch \nto the last weapon used \n and use Key:> ",str(array_of_inputs_keys[8])," < to the \n next weapon used by Megaman.\n Try it out!")
func pick_up_current_key_binding(action:String,keys_to_checked:InputEventAction,array_position:int):
	for keys in InputMap.action_get_events(action):
		if keys.get_physical_keycode()!=0:
			array_of_inputs_keys[array_position]=OS.get_keycode_string(keys.get_physical_keycode())
		else:
			array_of_inputs_keys[array_position]=OS.get_keycode_string(keys.get_keycode())
