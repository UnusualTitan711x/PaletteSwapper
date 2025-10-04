@tool
extends EditorPlugin

var toolbar

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	
	toolbar = preload("res://addons/palette_swapper/panel.tscn").instantiate()
	
	#add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, toolbar)
	#add_control_to_bottom_panel(toolbar, "Swapper")
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, toolbar)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	#remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, toolbar)
	#remove_control_from_bottom_panel(toolbar)
	remove_control_from_docks(toolbar)
	
	toolbar.free()
