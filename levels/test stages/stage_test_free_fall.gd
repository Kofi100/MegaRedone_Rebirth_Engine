extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.set_stage_name("TEST STAGE 2 \n :FREE FALL")
	GlobalScript.reset_boss_before_starting_stage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_port_test_1_body_entered(body):
	if body.is_in_group("player"):
		body.global_position=$port_test2.global_position


func _on_port_test_2_body_entered(body):
	if body.is_in_group("player"):
		body.global_position=$port_test1.global_position
