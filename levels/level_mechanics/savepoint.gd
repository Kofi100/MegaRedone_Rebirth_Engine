extends Node2D
var saved_player_position=false
@onready var detect_player_shape_cast_2d = $detect_player_ShapeCast2D
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#calculations done in the second arg of set_point_positon=grab local pos #get_collision_point(1)
	if $detect_player_ShapeCast2D.is_colliding():
		$line_rep.set_point_position(1,(detect_player_shape_cast_2d.get_collision_point()-global_position))
	else:
		$line_rep.set_point_position(1,(global_position-Vector2(0,240))-global_position)
	if detect_player_shape_cast_2d.is_colliding():
		var body=detect_player_shape_cast_2d.get_collider() #get_collider(1)
		if body!=null and body.is_in_group('player') and saved_player_position==false:
			GlobalScript.playerposx=global_position.x
			GlobalScript.playerposy=global_position.y-10
			GlobalScript.save_savepoint_data()
			saved_player_position=true
			body=null
			#queue_free()
			
	match saved_player_position:
		false:#$line_rep.default_color=Color.RED#(ffffff)
			animation_player.play("red")
		true:
			pass
			#$line_rep.default_color=Color.GREEN
			animation_player.play("green")


