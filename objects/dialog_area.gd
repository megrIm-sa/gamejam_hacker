extends Area2D

@export_multiline var text : String
var shown : bool


func _ready() -> void:
	shown = false


func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	if !body is Player or shown:
		return
	
	get_parent().get_parent().dialog_window.show_dialog(text)
	shown = true
