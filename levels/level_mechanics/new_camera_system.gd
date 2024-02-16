extends Area2D
var player_camera
@onready var zone_camera_2d = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_entered(area):
	if area.is_in_group('player_constants_checker_area2d') :#and area.get_parent().player_ready==true
		player_camera=area.get_parent().get_node('player_camera')
		if player_camera!=null:
			StageFunctions.switch_camera(player_camera,zone_camera_2d)
			GlobalScreenTransitionTimer.start()
		elif player_camera==null:
			push_error('player camera:cannot be found/no trans. therefore')
