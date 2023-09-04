extends Node2D
@onready var stage_camera = $stage_camera
@onready var player_camera= $megaman/player_camera

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_camera.limit_bottom=stage_camera.limit_bottom
	player_camera.limit_left=stage_camera.limit_left
	player_camera.limit_right=stage_camera.limit_right
