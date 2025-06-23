extends StaticBody2D
@export var speedInPixels:float=60.0
@export_enum("Left","Right")var direction:String="Left"

func _physics_process(delta: float) -> void:
	match direction:
		"Left":
			constant_linear_velocity.x=-speedInPixels
		"Right":
			constant_linear_velocity.x=speedInPixels
