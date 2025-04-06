extends Button


func _pressed() -> void:
	get_parent().get_parent().get_parent().level_finished.emit()
