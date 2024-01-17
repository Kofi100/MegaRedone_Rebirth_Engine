extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$bgm.play()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalScript.health<=0:$bgm.stop()


func _on_bgm_finished():
	#$bgm.play()
	pass
