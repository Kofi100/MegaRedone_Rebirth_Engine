extends Node2D
@onready var stage_camera = $all_camera/stage_camera
@onready var player_camera= $megaman/player_camera

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.spawn_enemy=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	StageFunctions.switch_camera(player_camera,stage_camera)

func _on_enter_player_body_entered(body):
	if body.is_in_group("player"):
		#print("done")
		StageFunctions.switch_camera(player_camera,stage_camera)
