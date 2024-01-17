extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_select_option_1_pressed():
	get_tree().change_scene_to_file('res://levels/test stages/stage_1.tscn')
