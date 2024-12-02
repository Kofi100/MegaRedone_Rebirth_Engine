@tool
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
@export var visibility_enemy_display=false
@export var enemy_dictionary:Dictionary={
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
	'ceiling_shooter':preload('res://enemy/original/ceiling_shooter.tscn'),
	'tacklefire': preload("res://assets/sprites/enemies/tacklefire.tscn"),
	"upndown" :preload("res://enemy/upndown.tscn"),
	"enemy_2" :preload("res://enemy/original/enemy_2.tscn")
}
var disappear_nodes={
	1:'Sprite2D',
	2:'index',
	3:'enemy',
	4:'enemy_spawn_list',
}
# Called when the node enters the scene tree for the first time.
var spawn_timer:int=0
func _ready():
	pass
var spawn_homer=false
var has_enemy_spawned=false
var display_node
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _enter_tree():
	request_ready()
func _process(_delta):
	display_node=get_node_or_null("enemy_display_sprite")
	if visibility==true:
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
	#to be used later

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
				var enemy_scene=enemy_dictionary.get(enemy_to_spawn)
				new_enemy=enemy_scene.instantiate()
				#if node_to_add_to_enemy!=null:
					#new_node=node_to_add_to_enemy.duplicate()
				#if node_to_add_to_enemy!=null and new_node!=null:
					##new_node.parent
					#new_node.reparent(new_enemy)
					#new_enemy.add_child(new_node)
					
				#new_enemy.index=spawn_index
				new_enemy.position=position
				get_parent().add_child(new_enemy)
				#entered=false
				#print(name,'[enemy_spawner]:new_node_to_add:[new node]-> ',new_node)
		if (enemy_to_spawn=='homer' or enemy_to_spawn=="upndown") and new_enemy==null and $spawn_homer_timer.time_left<=0:
			$spawn_homer_timer.start()
			#print(name,":started respawn timer for upndown and homer")
	
	elif entered==false and new_enemy==null:
		
		#timer=0
		has_enemy_spawned=false
	if enemy_to_spawn=='tacklefire':
		
		spawn_timer+=1
		if spawn_timer%30==1:
			has_enemy_spawned=false
#region Previous code to stop enemies upon transitioning to new screen
	# previous code to stop enemies upon transitioning to new screen
	#if GlobalScreenTransitionTimer.time_left>0:
		##for i in get_tree().current_scene.get_children():
			##if i is enemy:
		##if new_enemy!=null:
		#if new_enemy!=null:
				#new_enemy.set_physics_process(false)
				#new_enemy.velocity=Vector2.ZERO
	#elif GlobalScreenTransitionTimer.time_left<=0:
		##for i in get_tree().current_scene.get_children():
			##if i is enemy:
			#if new_enemy!=null:
				#new_enemy.set_physics_process(true)
		#if new_enemy!=null:
			#new_enemy.set_physics_process(true)
	#
#func check_for_dead_enemy(index):
##	if index==spawn_index:
##		has_enemy_spawned=false
	#if enemy_to_spawn=='homer':
		#$spawn_homer_timer.start()
#endregion
	if display_node!=null:
		display_node.visible=visibility_enemy_display
		display_enemy("new_shotman",0)
		display_enemy("mechakkero",1)
		display_enemy("peterchy",2)
		display_enemy("walking_bomb",3)
		display_enemy("met",4)
		display_enemy("sniper_joe",5)
		display_enemy("octopus_battery",6)
		display_enemy("homer",8)
		display_enemy("paraysu",9)
		display_enemy("pickelman_bull",10)
		display_enemy("yambou",11)
		display_enemy("spikyoall",12)
		display_enemy("ceiling_shooter",13)
		
	


func display_enemy(enemy_name:String,frame_display:int):
	if enemy_to_spawn==enemy_name:
		$enemy_display_sprite.frame=frame_display


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

func _on_spawn_homer_timer_timeout():
	print('enemy spawner: spawner homer timeout') #and enemy_to_spawn=='homer'
	if has_enemy_spawned  and new_enemy==null and $VisibleOnScreenNotifier2D.is_on_screen()==true:
		has_enemy_spawned=false

func _on_visible_on_screen_notifier_2d_screen_exited():
	entered=false
