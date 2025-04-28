extends Node2D

func _physics_process(delta: float) -> void:
	pass
	position.y-=50*delta
	z_index=1


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
