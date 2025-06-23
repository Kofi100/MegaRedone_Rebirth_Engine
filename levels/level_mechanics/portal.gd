@tool
@icon("res://assets/sprites/miscelleaneous/icons/nodes/portal_icon.png")
class_name Portal
extends Node2D

var portal_id:int=0
@onready var collision_shape_2d = $detect_player_area2d/CollisionShape2D

@export var next_portal:Portal
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var player
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if next_portal!=null:
		if player!=null:
			if $Timer.time_left<=0:
				$detect_player_area2d/CollisionShape2D.disabled=false
				next_portal.collision_shape_2d.disabled=false
			elif $Timer.time_left>0:
				$detect_player_area2d/CollisionShape2D.disabled=true
				next_portal.collision_shape_2d.disabled=true
			if $Timer.time_left<2 and $Timer.time_left>1.5:
				GlobalScreenTransitionTimer.stop()
				player.global_position=next_portal.global_position
				player.stop=false
				player.velocity.y=-300
				
			if $Timer.time_left>1.5 and $Timer.time_left<1.6: player.visible=true
			if $Timer.time_left>2:
				player.stop=true
				player.visible=false


func _on_detect_player_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if next_portal!=null:
			player=body;
			#body.global_position=next_portal.global_position
			#body.velocity.y=-300
			$AnimatedSprite2D.play("portal")
			$Timer.start()
