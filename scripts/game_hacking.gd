extends Control

signal play_pressed
signal restart_pressed


func _on_play_button_pressed() -> void:
	play_pressed.emit()
	print("play")


func _on_restart_button_pressed() -> void:
	restart_pressed.emit()
	print("restart")
