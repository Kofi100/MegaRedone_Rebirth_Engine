extends Node2D
var explosion=preload('res://miscellenaous/effects/explosion_particle.tscn')
var limit=9;var new;var i=1
# Called when the node enters the scene tree for the first time.
func _ready():
	var explosion_instance=explosion.instantiate()
	explosion_instance=explosion_instance.duplicate()
	for i in limit:
		if i!=0:
			new=explosion_instance.duplicate()
			add_child(new)
			new.state=i
			
			#print(i)
	for j in limit:
		if j!=0:
			new=explosion_instance.duplicate()
			add_child(new)
			new.state=j
			new.SPEED=new.SPEED/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
