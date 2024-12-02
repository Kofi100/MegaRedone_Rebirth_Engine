extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$bgm.play()
	$bgm.play()
	GlobalScript.set_stage_name("STAGE 2(???)")
	GlobalScript.reset_boss_before_starting_stage()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalScript.health<=0:$bgm.stop()


func _on_bgm_finished():
	#$bgm.play()
	pass
	$bgm.play(76.5)
