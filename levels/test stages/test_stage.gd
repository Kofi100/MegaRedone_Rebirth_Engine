extends Node2D
@onready var stage_camera = $all_camera/stage_camera
@onready var player_camera= $megaman/player_camera

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.spawn_enemy=true
	#$bgm.volume_db=-15
	GlobalScript.set_stage_name("TEST STAGE")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	StageFunctions.switch_camera(player_camera,stage_camera)
	#StageFunctions.loop_music($bgm,0,354.48)
	StageFunctions.loop_music($bgm,0,273)
	#print($bgm.get)

func _on_enter_player_body_entered(body):
	if body.is_in_group("player"):
		#print("done")
		StageFunctions.switch_camera(player_camera,stage_camera)
