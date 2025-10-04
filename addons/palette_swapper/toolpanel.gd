@tool
extends VBoxContainer

@onready var picker: AddonResourcePicker = %AddonResourcePicker
@onready var sprite: Sprite2D = $SubViewport/Sprite2D
@onready var viewport: SubViewport = $SubViewport
@onready var file_dialog: FileDialog = $FileDialog

var texture
var shader = preload("res://addons/palette_swapper/test_swap.gdshader")
var mat : ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	picker.texture_selected.connect(_on_texture_selected)
	
	mat = ShaderMaterial.new()
	mat.shader = shader
	sprite.material = mat
	sprite.texture = texture
	
	
	$TextureRect.texture = viewport.get_texture()
	

func _on_texture_selected(tex: Texture2D):
	# resize and center the viewport to fit the texture
	viewport.size = tex.get_size()
	sprite.position = viewport.size / 2.0
	
	sprite.texture = tex

func _on_target_color_picker_color_changed(color: Color) -> void:
	mat.set_shader_parameter("target_color", color)

func _on_replace_color_picker_color_changed(color: Color) -> void:
	mat.set_shader_parameter("replace_color", color)

func _on_tolerance_value_changed(value: float) -> void:
	mat.set_shader_parameter("tolerance", value)

func bake(source: Texture2D, target_color: Color, replace_color: Color, tolerance: float) -> ImageTexture:
	var img : Image = source.get_image()
	
	var working_img = Image.create(img.get_width(), img.get_height(), false, img.get_format())
	working_img.copy_from(img)
	
	# For safe manipulation of pixels
	for y in range(working_img.get_height()):
		for x in range(working_img.get_width()):
			var c = working_img.get_pixel(x, y)
			
			# Closeness to color
			if color_distance(c, target_color) < tolerance:
				
				var new_color = Color.from_hsv(
					replace_color.h, # Replace hue
					c.s, # Replace saturation
					c.v, # Maintain the same brightness
					c.a # Maintain alpha
				)
				
				# Replace the pixel with its new color
				working_img.set_pixel(x, y, new_color)
	
	# Output hte final texture
	var out = ImageTexture.create_from_image(working_img)
	return out

func color_distance(color1: Color, color2: Color) -> float:
	# differences between each color
	var dr = color1.r - color2.r
	var dg = color1.g - color2.g
	var db = color1.b - color2.b
	
	var result = sqrt(dr * dr + dg * dg + db * db)
	return result

	

func _on_apply_button_pressed() -> void:
	if sprite.texture:
		file_dialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	save_image_to_path(path)

func save_image_to_path(path: String):
	var result = bake(
		sprite.texture,
		mat.get_shader_parameter("target_color"), 
		mat.get_shader_parameter("replace_color"), 
		mat.get_shader_parameter("tolerance")
	)
	
	var image : Image = result.get_image()
	
	image.save_png(path + ".png")
	EditorInterface.get_resource_filesystem().scan()
	

func save_baked_texture(texture: ImageTexture):
	var img : Image = texture.get_image()
	img.save_png("res://new2.png")
	
	#Refresh the editor
	EditorInterface.get_resource_filesystem().scan()

func next_pass():
	var current_tex = sprite.texture
	var next_tex = bake(
		sprite.texture,
		mat.get_shader_parameter("target_color"), 
		mat.get_shader_parameter("replace_color"), 
		mat.get_shader_parameter("tolerance")
	)
	
	sprite.texture = next_tex


func _on_next_pass_pressed() -> void:
	next_pass()
