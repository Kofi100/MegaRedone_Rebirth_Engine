extends Node2D

var randomize_boss_picker:int=-1
@export var weapon_capsules={}
@export var node_to_go_to:Node2D
@export var return_points={}
@export var health_tween_create:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var picked_capsule=false;var picked_node_capsule;var not_picked_weapons
@export var engine_start:bool=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(randomize_boss_picker,'   ',$all_timers/active_timer.time_left)#picked_node_capsule.active
	if engine_start==true:
		if health_tween_create==false:
			var health_tween=create_tween()
			health_tween.connect('finished',fix_health)
			health_tween.tween_property($health_of_all_bosses,'value',$health_of_all_bosses.max_value,1)
			health_tween_create=true
		$bosses_display.visible=true
		$screen_flicker.visible=true
		$screen_flicker.play("flicker")
		if not picked_capsule and node_to_go_to!=null:
			randomize_boss_picker=randi_range(0,2)
			picked_node_capsule=get_node(weapon_capsules[randomize_boss_picker])
			if picked_node_capsule!=null:
				picked_capsule=true
				$bosses_display.frame=randomize_boss_picker
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
		
		
		if healthbar_ready:
			if get_node(weapon_capsules[0])!=null:
				health_capsule1=get_node(weapon_capsules[0]).health
			else:
				health_capsule1=0
			if get_node(weapon_capsules[1])!=null:
				health_capsule2=get_node(weapon_capsules[1]).health
			else:
				health_capsule2=0
			if get_node(weapon_capsules[2])!=null:
				health_capsule3=get_node(weapon_capsules[2]).health
			else:
				health_capsule3=0
			$health_of_all_bosses.value=health_capsule1+health_capsule2+health_capsule3
	
	
	elif not engine_start:
		$bosses_display.visible=false
		$screen_flicker.visible=false
		$screen_flicker.stop()
	if get_node(weapon_capsules[0])==null and get_node(weapon_capsules[1])==null and get_node(weapon_capsules[2])==null:
		$explosion.set_emitting(true)
		$explosion.reparent(get_tree().current_scene)
		
		queue_free()
var health_capsule1;var health_capsule2;var health_capsule3
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


func _on_engine_start_timer_timeout():
	engine_start=true
var healthbar_ready=false
func fix_health():
	$health_of_all_bosses.value=get_node(weapon_capsules[0]).health+ get_node(weapon_capsules[1]).health+get_node(weapon_capsules[2]).health
	healthbar_ready=true
