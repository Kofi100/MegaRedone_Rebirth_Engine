extends StaticBody2D
@export var door_id:int=0

# Called when the node enters the scene tree for the first time.
func _ready():
	state="closed"
@onready var door_animated_sprite_2d = $door_animated_sprite_2d

var state
var delete_a_key=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#for i in get_tree().current_scene.get_children():
		#if i is CharacterBody2D and i.is_in_group("key"):
			#if i.id==door_id:
				#pass
	#print(get_tree().current_scene.get_groups())
	match state:
		"closed":
			$CollisionShape2D.disabled=false
			$ColorRect.color=Color.RED
			door_animated_sprite_2d.frame=0
			#door_animated_sprite_2d.play_("open_close")
		"opened":
			$CollisionShape2D.disabled=true
			$ColorRect.color=Color.GREEN_YELLOW
	#print(get_tree().current_scene.get_)
	for i in get_tree().current_scene.get_children():
				if  i.is_in_group("key"):
					#print(i)
					pass

func _on_detect_key_player_body_entered(body):
	if body.is_in_group("player") and state=="closed":
		if body.key_dictionary.has(door_id):
			print(body.name," old key_dictionary->",body.key_dictionary,"\n")
			body.key_dictionary.erase(door_id)
			
			print(body.name," new key_dictionary->",body.key_dictionary)
			if delete_a_key==false:
				for i in get_tree().current_scene.get_children():
					if  i.is_in_group("key"):
						#print(i)
						if i.id==door_id:
							i.queue_free()
							delete_a_key=true
							print("one key deleted")
			state="opened"
			door_animated_sprite_2d.play("open_close")


func _on_detect_key_player_area_entered(area):
	if area.is_in_group("key") and state=="closed":
		state="opened"
		door_animated_sprite_2d.play("open_close")
		var key_Scene=area.get_parent()
		key_Scene.queue_free()
