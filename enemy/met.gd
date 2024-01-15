extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer
@onready var timer_2 = $Timer2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	health=3
	playerdamagevalue=5
	enemyreceivedamagevalue=1
	animated_sprite_2d.play("defend")

func _process(delta):
	if not is_on_floor():
		velocity.y+=gravity*delta

func _physics_process(delta):
	#print(health)
	$health.text=str(health)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y=0
		
	if player_on_left:
		animated_sprite_2d.flip_h=false
	if player_on_right:
		animated_sprite_2d.flip_h=true
	match animated_sprite_2d.animation:
		"shoot":
			#$hitbox_blocked/CollisionShape2D.disabled=true
			$hitbox_blocked.set_collision_layer_value(1,false)
			$hitbox/CollisionShape2D.disabled=false
		"defend":
			#$hitbox_blocked/CollisionShape2D.disabled=false
			$hitbox_blocked.set_collision_layer_value(1,true)
			$hitbox/CollisionShape2D.disabled=true
	spawn_collectables()
	move_and_slide()
var player_on_left=false;var player_on_right=false

func _on_left_body_entered(body):
	if body.is_in_group("player"):
		player_on_left=true
		timer.start()
func _on_left_body_exited(body):
	if body.is_in_group("player"):
		player_on_left=false
		timer.stop()

func _on_right_body_entered(body):
	if body.is_in_group("player"):
		player_on_right=true
		timer_2.start()


func _on_right_body_exited(body):
	if body.is_in_group("player"):
		player_on_right=false
		timer_2.stop()

var b1=preload("res://enemy/met_bullet.tscn");var b2=preload("res://enemy/met_bullet.tscn")
var b3=preload("res://enemy/met_bullet.tscn")
func _on_timer_timeout():
	if player_on_left:
		animated_sprite_2d.play("shoot")
		#animated_sprite_2d.flip_h=false
		var b1_ins=b1.instantiate();var b2_ins=b2.instantiate();var b3_ins=b3.instantiate()
		b1_ins.initial_direction="left";b2_ins.initial_direction="left";b3_ins.initial_direction="left";
		b1_ins.direction=1;b2_ins.direction=2;b3_ins.direction=3
		get_parent().add_child(b1_ins);get_parent().add_child(b2_ins);get_parent().add_child(b3_ins);
		b1_ins.global_position=global_position;b2_ins.global_position=global_position;
		b3_ins.global_position=global_position;

func _on_timer_2_timeout():
	if player_on_right:
		animated_sprite_2d.play("shoot")
		#animated_sprite_2d.flip_h=true
		var b1_ins=b1.instantiate();var b2_ins=b2.instantiate();var b3_ins=b3.instantiate()
		b1_ins.initial_direction="right";b2_ins.initial_direction="right";b3_ins.initial_direction="right";
		b1_ins.direction=1;b2_ins.direction=2;b3_ins.direction=3
		get_parent().add_child(b1_ins);get_parent().add_child(b2_ins);get_parent().add_child(b3_ins);
		b1_ins.global_position=global_position;b2_ins.global_position=global_position;
		b3_ins.global_position=global_position;

func _on_animated_sprite_2d_animation_finished():
	match animated_sprite_2d.animation:
		"shoot":
			animated_sprite_2d.play("defend")

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
