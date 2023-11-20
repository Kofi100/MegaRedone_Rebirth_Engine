extends Node2D
var charge_timer=0
var bodycolor1dictionary:Dictionary={
	0:Vector4.ZERO,
	1: Vector4(255,255,255,255),
	2: Vector4(255,255,255,255),
	3:Vector4(255,0,0,255),
}
var bodycolor2dictionary:Dictionary={
	0:Vector4.ZERO,
	1: Vector4(216,40,0,255,),
	2: Vector4(216,40,0,255),
	3:Vector4(255,0,0,255),
}
var weapon1energy=30
var weapon2energy=30
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func charge_effect(animated_sprite:AnimatedSprite2D):
	if charge_timer==0:
		animated_sprite.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
		animated_sprite.material.set_shader_parameter("bodycolori",(Vector4(136.0,232.0,255.0,255.0))/255)
		animated_sprite.material.set_shader_parameter("bodycolorii",(Vector4(0.0,98.0,247.0,255.0))/255)
	elif charge_timer>0 and charge_timer<30:
		if charge_timer%10==1:
			#print('mega chargeeffect:active1')
			animated_sprite.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif charge_timer%10==5:
			#print('mega chargeeffect:active1:2')
			animated_sprite.material.set_shader_parameter("outlinecolor",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif charge_timer>=30 and charge_timer<45:
		if charge_timer%10==1:
			animated_sprite.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif charge_timer%10==5:
			animated_sprite.material.set_shader_parameter("outlinecolor",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif charge_timer>=45:
		#animated_spriteated_sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		if charge_timer%10==1:
			animated_sprite.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("bodycolori",(Vector4(0.0,0.0,0.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("bodycolorii",(Vector4(0.0,98.0,247.0,255.0))/255)
		elif charge_timer%10==5:
			animated_sprite.material.set_shader_parameter("bodycolori",(Vector4(136.0,232.0,255.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("bodycolorii",(Vector4(0.0,0.0,0.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("outlinecolor",(Vector4(0.0,98.0,247.0,255.0))/255)

func change_palette(animated_sprite:AnimatedSprite2D):
		print('active')
		if bodycolor1dictionary.has(GlobalScript.weapon_number):
			animated_sprite.material.set_shader_parameter("outlinecolor",(Vector4(0.0,0.0,0.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("bodycolori",(bodycolor1dictionary.get(GlobalScript.weapon_number))/255)
			animated_sprite.material.set_shader_parameter("bodycolorii",(bodycolor2dictionary.get(GlobalScript.weapon_number))/255)
