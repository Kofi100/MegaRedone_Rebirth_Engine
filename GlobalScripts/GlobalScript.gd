extends Node
var health =1
##This boolean checks if the player has been hit by an enemy's attack or not.
var playerhasbeenhit:bool=false
##This integer indicates how long the cooldown should be.
var playerhitcooldowntimer:int=0
# Called when the node enters the scene tree for the first time.
var playerposx=0
var energy_tank_no=10
var max_health=30
var scene_to_be_loaded_index:int
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerhasbeenhit:
		#print('Globalscript:playerhasbeenhit:works')
		playerhitcooldowntimer+=1
		if playerhitcooldowntimer==100:
			playerhitcooldowntimer=0
			playerhasbeenhit=false
