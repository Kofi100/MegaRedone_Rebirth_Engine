extends Node2D
@onready var line_2d = $Line2D
@onready var ray_cast_2d = $RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	line_2d.set_point_position(1,(ray_cast_2d.get_collision_point()-global_position))
	if ray_cast_2d.get_collider().is_in_group('player'):
		var player=ray_cast_2d.get_collider()
		
		if GlobalScript.playerhasbeenhit==false:
			GlobalScript.playerhasbeenhit=true
			GlobalScript.health-=2
			player.anim.play("stun_air")
		#print('Player node collided with:',player)
