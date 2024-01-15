extends RigidBody2D

@onready var animation_player = $AnimationPlayer

const JUMP_VELOCITY = -400.0

func _ready():
	#animation_player.set_autoplay('active')
	pass

func _on_hitbox_body_entered(body):
	pass # Replace with function body.
	if body.is_in_group('player'):
		GlobalScript.health+=8
		queue_free()
