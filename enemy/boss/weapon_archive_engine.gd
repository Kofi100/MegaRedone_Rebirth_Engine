extends Node2D
var randomize_boss_picker:int=0
@export var weapon_capsules={}
@export var node_to_go_to:Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var picked_capsule=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not picked_capsule and node_to_go_to!=null:
		randomize_boss_picker=randi_range(0,2)
		#weapon_capsules[randomize_boss_picker].animation_player.play('idle')
		var tween=create_tween()
		tween.tween_property(weapon_capsules[randomize_boss_picker],'global_position',node_to_go_to.global_position,.5)
		tween.connect('finished',activate_capsule)

func activate_capsule():
	weapon_capsules[randomize_boss_picker].state='active'
