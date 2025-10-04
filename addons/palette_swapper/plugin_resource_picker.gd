@tool
extends EditorResourcePicker

class_name AddonResourcePicker

signal texture_selected(tex: Texture2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_type = "Texture2D"
	resource_changed.connect(_on_resource_changed)

func _on_resource_changed(res: Resource):
	if res is Texture2D:
		emit_signal("texture_selected", res)
