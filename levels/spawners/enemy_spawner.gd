extends Node2D
@export var node_to_add_to_enemy:Node2D;
var new_node
@export var enemy_to_spawn:String=''
#@export var spawn_index:int
#var new_shotman=preload("")
#var peterchy=preload("res://enemy/peterchy.tscn")
#var mechakkero=preload()
#var walking_bomb=preload('res://enemy/walking_bomb.tscn')
var new_enemy
@export var visibility=true
var enemy_dictionary:Dictionary={
	'new_shotman':preload('res://enemy/new_shotman.tscn'),
	'mechakkero':preload("res://enemy/mechakkero.tscn"),
	'peterchy':preload('res://enemy/peterchy.tscn'),
	'walking_bomb':preload('res://enemy/walking_bomb.tscn'),
	'met':preload('res://enemy/met.tscn'),
	'sniper_joe':preload('res://enemy/sniper_joe.tscn'),
	'octopus_battery':preload('res://enemy/octopus_battery.tscn'),
	'hologran':preload('res://enemy/hologran.tscn'),
	'homer':preload('res://enemy/original/homer.tscn'),
	'paraysu':preload('res://enemy/paraysu.tscn'),
	'pickelman_bull':preload('res://enemy/pickelman_bull.tscn'),
	'yambou':preload('res://enemy/yambou.tscn'),
	'spikyoall':preload('res://enemy/original/spikyoall.tscn'),
	'ceiling_shooter':preload('res://enemy/original/ceiling_shooter.tscn')
}
var disappear_nodes={
	1:'Sprite2D',
	2:'index',
	3:'enemy',
	4:'enemy_spawn_list',
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
var spawn_homer=false
var has_enemy_spawned=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visibility:
		for i in disappear_nodes:
			if disappear_nodes.has(i) and i<=4:
				var node=get_node(disappear_nodes[i])
				node.visible=true;#print(i)
			
#			if i==5:
#				i=1
	elif not visibility:
		for i in disappear_nodes:
			if disappear_nodes.has(i):
				var node=get_node(disappear_nodes[i])
				node.visible=false;#print(i)
			if i==5:
				i=1
	
	if new_node==null and new_enemy!=null:
##		if int(delta)%1==1:
			print(name,':[var]new node:empty/null')
	#print(delta)
#	for i in disappear_nodes:
#		if disappear_nodes.has(i):

	#print('enemy spawner:get node(Sprite2d):',get_node(disappear_nodes[1]))
	#print(entered)
	#print( 'is_connected',$VisibleOnScreenNotifier2D.is_connected('screen_entered',_on_visible_on_screen_notifier_2d_screen_entered),',has_enemy_spawned:',has_enemy_spawned)
	#set_physics_process(false)
#	if GlobalScript.spawn_enemy:
#		if $VisibleOnScreenNotifier2D.is_connected('screen_entered',_on_visible_on_screen_notifier_2d_screen_entered)==false:
#			$VisibleOnScreenNotifier2D.connect('screen_entered',_on_visible_on_screen_notifier_2d_screen_entered)
#	elif not GlobalScript.spawn_enemy:
#		if $VisibleOnScreenNotifier2D.is_connected('screen_entered',_on_visible_on_screen_notifier_2d_screen_entered)==true:
#			$VisibleOnScreenNotifier2D.disconnect('screen_entered',_on_visible_on_screen_notifier_2d_screen_entered)
	#displays enemies to be spawned
	#print('new'+enemy_to_spawn)
	#testing if new variables can be made..kinda
#	var new='new_'+enemy_to_spawn
#	print(new)
	##
#	if not has_enemy_spawned:
#		if enemy_to_spawn=='homer' and  $spawn_homer_timer.time_left>0:
#			spawn_homer=false
	#$index.text=str(spawn_index)
	
	$enemy.text=enemy_to_spawn
	if entered==true and GlobalScreenTransitionTimer.time_left<=0:
		#timer+=1
#		if new_enemy==null and enemy_to_spawn!='homer':
#			has_enemy_spawned=false
#		elif new_enemy==null and enemy_to_spawn=='homer':
#			if
		#if timer==1:
		if not has_enemy_spawned and new_enemy==null:
			if enemy_dictionary.has(enemy_to_spawn):
				has_enemy_spawned=true
				var enemy=enemy_dictionary.get(enemy_to_spawn)
				new_enemy=enemy.instantiate()
				if node_to_add_to_enemy!=null:
					new_node=node_to_add_to_enemy.duplicate()
				if node_to_add_to_enemy!=null and new_node!=null:
					new_node.reparent(new_enemy)
					#new_enemy.add_child(new_node)
					
				#new_enemy.index=spawn_index
				new_enemy.position=position
				get_parent().add_child(new_enemy)
				entered=false
				print(new_node)
	elif entered==false:
		#timer=0
		has_enemy_spawned=false
	if GlobalScreenTransitionTimer.time_left>0:
		if new_enemy!=null:
			new_enemy.set_physics_process(false)
	elif GlobalScreenTransitionTimer.time_left<=0:
		if new_enemy!=null:
			new_enemy.set_physics_process(true)
	
func check_for_dead_enemy(index):
#	if index==spawn_index:
#		has_enemy_spawned=false
	if enemy_to_spawn=='homer':
		$spawn_homer_timer.start()

var entered=false;var timer=1
func _on_visible_on_screen_notifier_2d_screen_entered():
	entered=true

		
#		match enemy_to_spawn:
#			pass
#			'new_shotman':
#				var new_shotman_enemy=new_shotman.instantiate()
#				get_parent().add_child(new_shotman_enemy)
#				new_shotman_enemy.index=spawn_index
#				new_shotman_enemy.global_position=global_position
#			'peterchy':
#				var new_peterchy_enemy=peterchy.instantiate()
#				new_peterchy_enemy.position=position
#				new_peterchy_enemy.index=spawn_index
#				get_parent().add_child(new_peterchy_enemy)
#			'mechakkero':
#				var new_mechakkero_enemy=mechakkero.instantiate()
#				new_mechakkero_enemy.position=position
#				new_mechakkero_enemy.index=spawn_index
#				get_parent().add_child(new_mechakkero_enemy)
#			'walking_bomb':
#				var new_waling_bomb=walking_bomb.instantiate()


func _on_spawn_homer_timer_timeout():
	print('enemy spawner: spawner homer timeout')
	if has_enemy_spawned and enemy_to_spawn=='homer' and new_enemy==null and $VisibleOnScreenNotifier2D.is_on_screen()==true:
		has_enemy_spawned=false

func _on_visible_on_screen_notifier_2d_screen_exited():
	entered=false
