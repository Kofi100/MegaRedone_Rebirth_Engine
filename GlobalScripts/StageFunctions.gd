extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func switch_camera(main_camera:Camera2D,camera_to_switch:Camera2D):
	main_camera.limit_left=camera_to_switch.limit_left
	main_camera.limit_right=camera_to_switch.limit_right
	main_camera.limit_top=camera_to_switch.limit_top
	main_camera.limit_bottom=camera_to_switch.limit_bottom
	#print(name.to_camel_case()," -> switch camera function initiated")
##This stops any music sent as an argument from playing.
func stop_music(music_to_be_stopped:AudioStreamPlayer2D):
	music_to_be_stopped.stop()
##This starts/plays any music sent as an argument.
func play_music(music_to_be_started:AudioStreamPlayer2D):
	music_to_be_started.play()
func change_music(music_to_be_stopped:AudioStreamPlayer2D,music_to_be_started:AudioStreamPlayer2D):
	music_to_be_stopped.stop()
	music_to_be_started.play()
func pause_music(music_to_be_paused:AudioStreamPlayer2D):
	music_to_be_paused.set_stream_paused(true)
func resume_music(music_to_be_resumed:AudioStreamPlayer2D):
	music_to_be_resumed.set_stream_paused(false)
func play_music_audioplayer(audioplayer2d:AudioStreamPlayer,music_to_be_played_stream:AudioStream,position_to_play_from:float):
	audioplayer2d.stream=music_to_be_played_stream
	audioplayer2d.play(position_to_play_from)

func loop_music(audiostreamplayer:Object,position_restart:float,position_end:float):
	if audiostreamplayer is AudioStreamPlayer or audiostreamplayer is AudioStreamPlayer2D:
		if audiostreamplayer.get_playback_position()>=position_end:
			audiostreamplayer.play(position_restart)
	else:
		push_warning(name,":func loop_music():Audiostreamplayer is Not a AudioStreamPlayer or AudioStreamPlayer2D ")

func create_new_stuff(scene:PackedScene,variable:Node):
	variable=scene.instantiate()
	get_parent().add_child(variable)
