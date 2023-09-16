extends CharacterBody2D
##This is for declaring and placing every enemy under the power of OOP
class_name enemy
##This sets the starting health of an enemy
var health=1;
##This sets amount of damage a player should receive upon hitting an enemy
var playerdamagevalue=1
var enemyreceivedamagevalue=1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_collectables():
	if health<=0:
		queue_free()
