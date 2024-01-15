extends Node2D
var randomize_boss_picker:int=-1
@export var weapon_capsules={}
@export var node_to_go_to:Node2D
@export var return_points={}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var picked_capsule=false;var picked_node_capsule;var not_picked_weapons
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(randomize_boss_picker,'   ',$all_timers/active_timer.time_left)#picked_node_capsule.active
	if not picked_capsule and node_to_go_to!=null:
		randomize_boss_picker=randi_range(0,2)
		picked_node_capsule=get_node(weapon_capsules[randomize_boss_picker])
		if picked_node_capsule!=null:
			picked_capsule=true
			#weapon_capsules[randomize_boss_picker].animation_player.play('idle')
			var tween=create_tween()
			tween.tween_property(picked_node_capsule,'global_position',node_to_go_to.global_position,.5)
			tween.connect('finished',activate_capsule)
		elif picked_node_capsule==null:
			picked_capsule=false
#		var new_positionx=move_toward(get_node(weapon_capsules[randomize_boss_picker]).global_position.x,node_to_go_to.global_position.x,1000*delta)
#		get_node(weapon_capsules[randomize_boss_picker]).global_position.x=new_positionx
#		var new_positiony=move_toward(get_node(weapon_capsules[randomize_boss_picker]).global_position.y,node_to_go_to.global_position.y,1000*delta)
#		get_node(weapon_capsules[randomize_boss_picker]).global_position.y=new_positiony
	if picked_node_capsule==null and $all_timers/active_timer.time_left>0:
		picked_capsule=false
		$all_timers/active_timer.stop()
func activate_capsule():
	picked_node_capsule.active=true
	$all_timers/active_timer.start()

var return_node
func _on_active_timer_timeout():
	return_node=get_node(return_points[randomize_boss_picker])
	if picked_node_capsule!=null:
		picked_node_capsule.active=false
		picked_node_capsule.active_iceman=false
		var tween2=create_tween()
		tween2.tween_property(picked_node_capsule,'global_position',return_node.global_position,.5)
		tween2.connect('finished',reactivate_capsule)

func reactivate_capsule():
	picked_capsule=false
