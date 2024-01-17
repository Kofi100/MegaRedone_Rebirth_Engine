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
var max_health=30
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
func _ready():
	DisplayServer.window_set_size(DisplayServer.window_get_size()*3)
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
