extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	play("explosion")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animation_finished():
	queue_free()
