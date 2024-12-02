@tool
extends EditorPlugin

var dock

func _enter_tree():
	# Initialization of the plugin goes here.
	dock=preload("addon_dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_BR,dock)
	add_custom_type("New Camera System Addon","Area2D",preload("scenes/new_camera_system.gd"),preload("assets/new camera system icon.png"))


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_docks(dock)
	dock.free()
	remove_custom_type("New Camera System Addon")
