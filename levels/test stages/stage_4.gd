extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#$bgm.play()
var timer:int
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#GlobalScript.stage_name="PIPELINE FACTORY"
	timer+=1#*delta
	#debugging
	#for finding how many cells were used for the backgrounds_so therefore,how many rooms exist
	if timer==50: #and timer<0.7:#GlobalScript.second_level
		if $bgm.playing==false:
			$bgm.play()
	#print($TileMap2. get_used_cells_by_id(0).size())
	
	#debugging
	


func _on_bgm_finished():
	pass # Replace with function body.
	$bgm.play()
