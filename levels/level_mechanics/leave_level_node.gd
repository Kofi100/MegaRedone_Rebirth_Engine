extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_detect_player_body_entered(body):
	if body.is_in_group("player"):
		body.leave_timer.start()
		body.leave_bool=true
