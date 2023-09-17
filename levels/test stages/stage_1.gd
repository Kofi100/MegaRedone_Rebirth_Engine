extends Node2D
@onready var player_cam=$megaman/player_camera
@onready var camera_1 = $all_cameras/camera1
@onready var camera_2 = $all_cameras/camera2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_z_1_body_entered(body):
	if body.is_in_group("player"):
		pass
		StageFunctions.switch_camera(player_cam,camera_1)


func _on_z_2_body_entered(body):
	if body.is_in_group("player"):
		pass
		StageFunctions.switch_camera(player_cam,camera_2)
