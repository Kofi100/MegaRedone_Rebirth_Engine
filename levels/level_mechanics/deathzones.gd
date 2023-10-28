extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	if playerindeathzone:
		#print("deathzones:working")
		#if GlobalScript.playerhasbeenhit==false:
			GlobalScript.health=0
#	if !playerindeathzone:
#		print('duh2')
var playerindeathzone=false
func _on_body_entered(body):
	if body.is_in_group("player"):
		playerindeathzone=true
		#print("duh")


func _on_body_exited(body):
	if body.is_in_group("player"):
		playerindeathzone=false
