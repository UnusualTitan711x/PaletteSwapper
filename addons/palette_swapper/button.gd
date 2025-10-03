@tool
extends Button



func _on_pressed() -> void:
	var value = $"../SpinBox".value
	print("Number:", value)
