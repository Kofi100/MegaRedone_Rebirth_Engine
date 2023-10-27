extends Node2D
@export var enemy_to_spawn:String=''
@export var spawn_index:int
#var new_shotman=preload("")
#var peterchy=preload("res://enemy/peterchy.tscn")
#var mechakkero=preload()
#var walking_bomb=preload('res://enemy/walking_bomb.tscn')

var enemy_dictionary:Dictionary={
	'new_shotman':preload('res://enemy/new_shotman.tscn'),
	'mechakkero':preload("res://enemy/mechakkero.tscn"),
	'peterchy':preload('res://enemy/peterchy.tscn'),
	'walking_bomb':preload('res://enemy/walking_bomb.tscn'),
	'met':preload('res://enemy/met.tscn'),
	'sniper_joe':preload('res://enemy/sniper_joe.tscn'),
	'octopus_battery':preload('res://enemy/octopus_battery.tscn'),
	'hologran':preload('res://enemy/hologran.tscn')
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var has_enemy_spawned=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#displays enemies to be spawned
	#print('new'+enemy_to_spawn)
	#testing if new variables can be made..kinda
#	var new='new_'+enemy_to_spawn
#	print(new)
	##
	$index.text=str(spawn_index)
	$enemy.text=enemy_to_spawn
	
func check_for_dead_enemy(index):
	if index==spawn_index:
		has_enemy_spawned=false


func _on_visible_on_screen_notifier_2d_screen_entered():
	if not has_enemy_spawned:
		has_enemy_spawned=true
		var enemy=enemy_dictionary.get(enemy_to_spawn)
		var new_enemy=enemy.instantiate()
		new_enemy.index=spawn_index
		new_enemy.position=position
		get_parent().add_child(new_enemy)
		
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
