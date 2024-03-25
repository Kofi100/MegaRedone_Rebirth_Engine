extends Node2D
var save_keybinds_path="res://keybinds.txt"
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
@export var node_to_action={
	0:null,1:null,2:null,3:null,4:null,5:null,6:null,7:null,8:null,9:null
}
@export var option_to_action_dict={
	0:"move_up",1:"move_down",2:"move_left",3:"move_right",4:"jump",5:"dash",
	6:"shoot",7:"pause",8:"switch_weapon_left",9:"switch_weapon_right"
}
# Called when the node enters the scene tree for the first time.
func _ready():
	set_keys_to_players()

var display_label=false
var selected_option:int=0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$waiting_text_label.visible=display_label
	#display_label_fxn()
	for i in node_to_action:
		if node_to_action[i]!=null: #and node_to_action[i]
			var node=get_node(node_to_action[i])
			if node!=null:
				if node.get_focus_mode()==1:
					print(i)

var action_to_get
func _input(event):
	if display_label==true:
		if event is InputEventKey:
			if InputMap.has_action(option_to_action_dict[selected_option]) and event.is_released()==true:
				action_to_get=option_to_action_dict[selected_option]
				for i in InputMap.action_get_events(action_to_get):#input_dictionary_keys
					if i is InputEventKey:
						print(i)
						InputMap.action_erase_event(action_to_get,i)
						InputMap.action_add_event(action_to_get,event)
						print('previous keybind deleted, added new key:',OS.get_keycode_string(event.keycode))
						save_keybinds(event)
						display_label=false
				#InputMap.era
	

func save_keybinds(key):
	if key is InputEventKey:
		input_dictionary_keys[action_to_get]=key.keycode
		
		var file_open=FileAccess.open(save_keybinds_path,FileAccess.WRITE)
		if file_open.is_open()==true:print('\n file opened')
		if file_open!=null:
			file_open.store_string(str(input_dictionary_keys))
			print('\n file stored input dictionary')
			file_open.close()
			print('\n input keybinds saved successfully 🥳')

func set_keys_to_players():
	var file_set=FileAccess.open(save_keybinds_path,FileAccess.READ)
	if file_set!=null:print(name,' --> opened keybind save file successfully')#.is_open()
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
			print(name,'-> keybinds_as_dict:null: creating new file...')
			var file_open=FileAccess.open(save_keybinds_path,FileAccess.WRITE)
			if file_open.is_open()==true:print('\n file opened')
			if file_open!=null:
				file_open.store_string(str(input_dictionary_keys))
				print('\n file stored input dictionary')
				file_open.close()
				print('\n input keybinds saved successfully 🥳')
		
		
	elif file_set==null:
		print('file_set:null: creating new file...')
		var file_open=FileAccess.open(save_keybinds_path,FileAccess.WRITE)
		if file_open.is_open()==true:print('\n file opened')
		if file_open!=null:
			file_open.store_string(str(input_dictionary_keys))
			print('\n file stored input dictionary')
			file_open.close()
			print('\n input keybinds saved successfully 🥳')

func display_label_fxn():
	if display_label==false:
		display_label=true
	elif display_label==true:
		display_label=false


func _on_up_btn_pressed():
	selected_option=0


func _on_down_btn_pressed():
	pass # Replace with function body.
	selected_option=1


func _on_left_btn_pressed():
	pass # Replace with function body.
	selected_option=2


func _on_main_menu_pressed():
	get_tree().change_scene_to_file('res://levels/main_menu.tscn')


func _on_right_btn_pressed():
	selected_option=3


func _on_jump_btn_pressed():
	selected_option=4


func _on_slide_btn_pressed():
	selected_option=5


func _on_shoot_btn_pressed():
	selected_option=6
