class_name SimonElement
extends TextureButton

signal element_clicked(element : TextureButton)


func _pressed() -> void:
	element_clicked.emit(self)
