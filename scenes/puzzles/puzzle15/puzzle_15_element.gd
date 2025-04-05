class_name Puzzle15Element
extends TextureButton

@export var correct_id: int
@export var is_empty: bool

signal slot_clicked(slot : TextureButton)


func _ready():
	await get_tree().process_frame
	
	if is_empty:
		texture_normal = null
		texture_pressed = null
		$Label.text = ""
	else:
		$Label.text = str(correct_id+1)


func _pressed() -> void:
	if is_empty:
		return
	slot_clicked.emit(self)
