extends enemy
@onready var animation_player = $bulb/AnimationPlayer

var speed=4000
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("activate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$bulb.velocity.x=-speed*delta
	$bulb.move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name=='activate':
		animation_player.play("active")
