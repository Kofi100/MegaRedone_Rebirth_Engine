extends Node2D
@onready var bgm = $bgm


# Called when the node enters the scene tree for the first time.
func _ready():
	bgm.play()
	GlobalScript.set_stage_name("CYBERSPACE \n(DEMO)")
	GlobalScript.reset_boss_before_starting_stage()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($TileMap2.get_used_cells(0).size())
	StageFunctions.loop_music($bgm,3.38,167)
	#print(name,":Screen count:",$all_camera_systems.get_child_count(false))

func _on_bgm_finished():
	bgm.play()
