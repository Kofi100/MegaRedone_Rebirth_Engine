extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#$bgm.play()
	GlobalScript.reset_boss_before_starting_stage()
	GlobalScript.set_stage_name("PIPELINE \n FACTORY")
	GlobalScript.player=$megaman
	GlobalScript.boss=$fireman_boss
	GlobalScript.boss.set_physics_process(false)
	
var timer:int
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#GlobalScript.stage_name="PIPELINE FACTORY"
	timer+=1#*delta
	#print(name,"::fireman_Active::",GlobalScript.boss.is_physics_processing())
#region Debugging
	#debugging
	#for finding how many cells were used for the backgrounds_so therefore,how many rooms exist
	#print($TileMap2. get_used_cells_by_id(0).size())
#endregion

	if timer==50: #and timer<0.7:#GlobalScript.second_level
		if $bgm.playing==false:
			$bgm.play()
	
	
	#debugging
	if $fireman_boss.health<=0:
		boss_defeated()
var left=false

func boss_defeated():
	if $megaman.leave_bool==false:
		$megaman.leave_bool=true
#region temporal check for leaving screens
	if $megaman/leave_timer.time_left==0 and left==false:
		$megaman/leave_timer.start()
		left=true


func _on_bgm_finished():
	pass # Replace with function body.
	$bgm.play()

func _on_boss_zone_area_entered(area):
	pass # Replace with function body.
	if area.is_in_group("player_constants_checker_area2d"):
			$start_boss_timer.start()
			print("Player constant checker entered")


func _on_start_boss_timer_timeout():
	GlobalScript.trigger_boss=true
	GlobalScript.boss.activate_boss=true
