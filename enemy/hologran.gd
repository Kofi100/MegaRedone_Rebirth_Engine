extends enemy
@onready var animation_player = $bulb/AnimationPlayer

@export var speed=4000
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("active")
	#$bulb/ColorRect.visible=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if animation_player.current_animation!='activate':
		$bulb.velocity.x=-speed*delta
	else: $bulb.velocity.x=0
	$bulb.move_and_slide()
	$bulb/ColorRect.global_position=Vector2(GlobalScript.playerposx,GlobalScript.playerposy)


func _on_visible_on_screen_notifier_2d_screen_exited():
	animation_player.play("about_to_leave")


@warning_ignore("unused_parameter")
func _on_animation_player_animation_finished(anim_name):
	if anim_name=='activate':
#		var tween=create_tween()
#		tween.tween_property($hologram,'Color',Vector4(0,0,0,255))
		#$bulb/ColorRect.visible=true
#		animation_player.play("active")
		animation_player.play("hologramed")
	if anim_name=='about_to_leave':
		queue_free()


func _on_timer_timeout():
	pass # Replace with function body.
	animation_player.play("activate")
