extends Node2D
var boss_defeated:bool=false

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.set_stage_name("TEST BOSS \nROOM 2")
	GlobalScript.reset_boss_before_starting_stage()
	GlobalScript.player=$megaman
	GlobalScript.boss=$fireman_boss
	GlobalScript.trigger_boss=false
	GlobalScript.boss.set_physics_process(false)
	$start_boss_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var signal_boss:Signal 
	
	if $fireman_boss !=null:
		#if $fireman_boss.has_signal("boss_defeated") and $fireman_boss.boss_defeated.is_connected("boss_dedeat"):
			#$fireman_boss.connect("$fireman_boss.boss_defeated",boss_dedeat)
		if $fireman_boss.health<=0:
			boss_dedeat()
var left=false
func boss_dedeat():
	if $megaman.leave_bool==false:
		$megaman.leave_bool=true
#region temporal check for leaving screens
	if $megaman/leave_timer.time_left==0 and left==false:
		$megaman/leave_timer.start()
		left=true
#endregion
		#body.leave_bool=true


func _on_start_boss_timer_timeout():
	GlobalScript.trigger_boss=true
	GlobalScript.boss.activate_boss=true
	$boss_theme_test.play()
	#print("oh yeahhh!")
	pass


func _on_boss_theme_test_finished():
	$boss_theme_test.play()
