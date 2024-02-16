extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$bgm.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#debugging
	#for finding how many cells were used 
	#print($TileMap2. get_used_cells_by_id(0).size())
	
	#debugging


func _on_bgm_finished():
	pass # Replace with function body.
	$bgm.play()
