class_name EndLevelTeleport
extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		get_parent().get_parent().level_finished.emit()
