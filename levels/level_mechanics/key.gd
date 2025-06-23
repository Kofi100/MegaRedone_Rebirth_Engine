extends CharacterBody2D
@export var id:int=0
var speed_randomized
# Called when the node enters the scene tree for the first time.
func _ready():
	speed_randomized=randi_range(30,70) 

var follow_player=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if follow_player==true and GlobalScreenTransitionTimer.time_left==0:
		#var new_posx=move_toward(global_position.x,GlobalScript.playerposx+10,speed_randomized*delta)
		#var new_posy=move_toward(global_position.y,GlobalScript.playerposy,speed_randomized*delta)#50
		#move_and_slide()
		#global_position.x=new_posx;global_position.y=new_posy
		global_position.x=GlobalScript.playerposx+20
		global_position.y=GlobalScript.playerposy

func _on_detect_door_area_body_entered(body):
	if body.is_in_group("player") and follow_player==false:
		body.key_dictionary.push_back(id)
		#queue_free()
		follow_player=true
	
