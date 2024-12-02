extends Node
var health =1
var previous_health=0
##This boolean checks if the player has been hit by an enemy's attack or not.
var playerhasbeenhit:bool=false
##This integer indicates how long the cooldown should be.
var playerhitcooldowntimer:int=0
# Called when the node enters the scene tree for the first time.
var playerposx=0;var playerposy=0
var energy_tank_no=3
var max_health=27
var scene_to_be_loaded_index:int
var weapon_number=0
var spawn_collectable_no:int=0
var spawn_enemy=true
var level_timer_start=false
var restarted_level=false
var minute_level=0
var second_level=0
var milliseconds=0
var total_time_seconds=0 #would be used to record how long you spent on a level
var restart_scene=false
var lemons_on_screen_no:int=0
var restarted_stage=false
var save_keybinds_path="res://keybinds.txt"#user:// -<stores in user appdata folder 
var score:int=0
#res://<- srtores in project folder
#res means resources
var savepoint_path="res://savepoint.txt"
var savepos_x=0;var savepos_y=0;
var stage_name:String
var boss_health:float=0;var trigger_boss:bool=false
var boss:Object;var player:Object
@export var input_dictionary_keys={
	"move_up":0,
	"move_down":0,
	"move_left":0,
	"move_right":0,
	"jump":0,
	"dash":0,
	"shoot":0,
	"pause":0,
	"switch_weapon_left":0,
	"switch_weapon_right":0,
	
}

func _ready():
	DisplayServer.window_set_size(DisplayServer.window_get_size()*3)
	set_keys_to_players()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#energy_tank_no=5
	if playerhasbeenhit:
		#print('Globalscript:playerhasbeenhit:works')
		
		playerhitcooldowntimer+=1
		if playerhitcooldowntimer==100:
			playerhitcooldowntimer=0
			playerhasbeenhit=false
	if health>=max_health:
		health=max_health
	if level_timer_start:
		second_level+=1*delta
		total_time_seconds+=1*delta
#		if milliseconds==100:
#			second_level+=1
		if second_level>=60:
			minute_level+=1
			second_level=0
	#set_stage_name()
	#print('GlobalScript:prev.health,current health:',GlobalScript.previous_health,',,, ',GlobalScript.health)

func start_level_timer():
	level_timer_start=true

func reset_level_timer():
	level_timer_start=false
	total_time_seconds=0
	second_level=0
	minute_level=0
	milliseconds=0
	
func pause_level_timer():
	level_timer_start=false

func set_keys_to_players():
	var file_set=FileAccess.open(save_keybinds_path,FileAccess.READ)
	if file_set!=null:print(name,'--> opened keybind save file successfully')#is_open():
	if file_set!=null:
		var keybinds_as_dict=str_to_var(file_set.get_line())
		print('saved keybinds_as_dict: ',keybinds_as_dict)
		if keybinds_as_dict!=null:
			for i in keybinds_as_dict:
				if input_dictionary_keys.has(i) and keybinds_as_dict[i]!=0 and keybinds_as_dict[i]!=null:
					input_dictionary_keys[i]=keybinds_as_dict[i]
					print('input_dictionary_keys->[',i,'] :',input_dictionary_keys[i])
					
					var new_InputKey=InputEventKey.new()
					new_InputKey.keycode=keybinds_as_dict[i]
					if InputMap.has_action(i):
						for prevkeys in InputMap.action_get_events(i):
							if prevkeys is InputEventKey:
								InputMap.action_erase_event(i,prevkeys)
								InputMap.action_add_event(i,new_InputKey)
								print('\n newKey set:action:',i,'->',OS.get_keycode_string(new_InputKey.keycode))
		elif keybinds_as_dict==null:
			print('GlobalScript:ready-->keybinds_as_dict:null: creating new file...')
			var file_open=FileAccess.open(save_keybinds_path,FileAccess.WRITE)
			if file_open.is_open()==true:print('\n file opened')
			if file_open!=null:
				file_open.store_string(str(input_dictionary_keys))
				print('\n file stored input dictionary')
				file_open.close()
				print('\n input keybinds saved successfully 🥳')
		
func save_savepoint_data():
	var savepoint_dictionary={
		"X":playerposx,
		"Y":playerposy
	}
	var savefile_write=FileAccess.open(savepoint_path,FileAccess.WRITE)
	savefile_write.store_var(savepoint_dictionary)
	push_warning("File saved sucessfully")
	print("savepoint_dict:",savepoint_dictionary)
	savefile_write.close()
func load_savepoint_data():
	var savefile_load=FileAccess.open(savepoint_path,FileAccess.READ)
	if savefile_load!=null:
		var saved_array=savefile_load.get_var()
		print("saved_pos_array/dict:",saved_array)
		if saved_array!=null:
			if saved_array.has("X") and saved_array.has("Y"):
				playerposx=saved_array.X
				playerposy=saved_array.Y
				print(name,'->[savepos_x,savepos_y]:',[savepos_x,savepos_y])
		elif saved_array==null:
			push_warning("Savefile doesn't have variables:creating a new savefile")
			save_savepoint_data()
	elif savefile_load==null:
		push_warning("Savefile doesnt exist:creating new savefile")
		save_savepoint_data()
var stage_path

func set_stage_name(name_of_stage:String):
	stage_name=name_of_stage
	#if get_tree().current_scene is Node2D:
		#stage_path=get_tree().current_scene.scene_file_path
	#if stage_path!=null:
		#match stage_path:
			#"res://levels/test stages/test_stage.tscn":
				#stage_name="TEST STAGE"
			#"res://levels/test stages/stage_1.tscn":
				#stage_name="???"
			#"res://levels/test stages/stage_2.tscn":
				#stage_name="??? 2"
			##"res://levels/test stages/stage_3.tscn":
				##stage_name="CYBERSPACE"
			#"res://levels/test stages/test_boss_room.tscn":
				#stage_name="TEST BOSS\n ROOM:\n the weapon archive"
			#"res://levels/test stages/stage_3.tscn":
				#stage_name="CYBERSPACE \n DEMO"
			#"res://levels/test stages/stage_4.tscn":
				#stage_name="PIPELINE \n FACTORY"
			#"res://levels/test stages/stage_5_junkman_test.tscn":
				#stage_name="TEST STAGE 5:\n JUNKMAN'S STAGE"
			
func reset_boss_before_starting_stage():
	boss=null
