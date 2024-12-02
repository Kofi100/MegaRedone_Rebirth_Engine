extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var damagereceived:float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$damage_of_shot.text=str(damagereceived).pad_zeros(2)
	if damagereceived!=0:
		$damage_of_shot.visible=true
	elif damagereceived==0:
		$damage_of_shot.visible=false
	if $Timer.time_left<=0:
		damagereceived=0

func _on_detect_player_shoot_area_entered(area):
	if area.is_in_group("player_projectiles"):
		damagereceived=area.get_parent().damagevalue
		area.get_parent().queue_free()
		$Timer.start()
