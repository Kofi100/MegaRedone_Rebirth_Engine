extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	GlobalScript.player=$megaman
	GlobalScript.boss=$wily_capsule_7


func _on_timer_timeout():
	GlobalScript.boss.activate_boss=true
	$AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
