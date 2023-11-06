extends enemy




@export var speed = 50.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	playerdamagevalue=3
	health=5

func _physics_process(delta):
	var new_pos=move_toward(global_position.x,GlobalScript.playerposx,speed*delta)
	var new_pos2=move_toward(global_position.y,GlobalScript.playerposy,speed*delta)
	move_and_slide()
	spawn_collectables()
	global_position.x=new_pos
	global_position.y=new_pos2


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	get_tree().call_group('enemy_spawner','check_for_dead_enemy',index)
