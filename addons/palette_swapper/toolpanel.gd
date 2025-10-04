@tool
extends VBoxContainer

@onready var picker: AddonResourcePicker = $HBoxContainer3/AddonResourcePicker
@onready var sprite: Sprite2D = $SubViewport/Sprite2D
@onready var viewport: SubViewport = $SubViewport

var texture
var shader = preload("res://testing/test_swap.gdshader")
var mat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	picker.texture_selected.connect(_on_texture_selected)
	
	mat = ShaderMaterial.new()
	mat.shader = shader
	sprite.material = mat
	sprite.texture = texture
	
	
	$TextureRect.texture = viewport.get_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_texture_selected(tex: Texture2D):
	
	
	sprite.texture = tex

func _on_target_color_picker_color_changed(color: Color) -> void:
	mat.set_shader_parameter("target_color", color)

func _on_replace_color_picker_color_changed(color: Color) -> void:
	mat.set_shader_parameter("replace_color", color)

func _on_tolerance_value_changed(value: float) -> void:
	mat.set_shader_parameter("tolerance", value)
