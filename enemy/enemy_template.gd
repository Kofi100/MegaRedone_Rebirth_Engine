extends CharacterBody2D
##This is for declaring and placing every enemy under the power of OOP
class_name enemy
##This sets the starting health of an enemy
var health=1;
##This sets amount of damage a player should receive upon hitting an enemy
var playerdamagevalue=1
var enemyreceivedamagevalue=1
var state=''
var index:int
var distance_x:int=0
var boss_defeated:Signal
var collectables_list={
	1: preload('res://miscellenaous/small_health_capsule.tscn'),
	2:preload('res://miscellenaous/large_health_capsule.tscn'),
	3:preload('res://miscellenaous/small_weapon_capsule.tscn'),
	4:preload('res://miscellenaous/large_health_capsule.tscn'),
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var is_boss=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_boss==false:
		if GlobalScreenTransitionTimer.time_left>0:
			set_physics_process(false)
		elif GlobalScreenTransitionTimer.time_left<=0:
			set_physics_process(true)
var collectable
func calculate_player_distance():
	distance_x=GlobalScript.playerposx-global_position.x
func spawn_collectables():
	if health<=0:
		#get_tree().call_group('enemy_spawner','check_for_dead_enemy',index)
		if is_boss==false:
			GlobalScript.spawn_collectable_no=randi_range(1,18)
			if collectables_list.has(GlobalScript.spawn_collectable_no):
				collectable=collectables_list[GlobalScript.spawn_collectable_no]
			
			if collectable!=null:
				var new_collectable=collectable.instantiate()
				new_collectable.position=position
				get_parent().add_child(new_collectable)
				if new_collectable.delete_spawnable_timer!=null:
					#print('delete timer triggered')
					new_collectable.delete_spawnable_timer.start()
			else:
				print('its a null case of the collectanles')
				print('spawn_collectable_no:',GlobalScript.spawn_collectable_no)
			queue_free()
		if is_boss==true:
			boss_defeated.emit()
			self.set_physics_process(false)
			self.visible=false
			self.global_position=Vector2(-500,500)
		var explosion=preload('res://enemy/effects/explosion_enemy.tscn')
		var explsion_new=explosion.instantiate()
		get_parent().add_child(explsion_new)
		explsion_new.position=position

#func calculate_Player_Distance():
	#distance_x=GlobalScript.playerposx-global_position.x
