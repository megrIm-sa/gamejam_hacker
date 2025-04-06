class_name GameHacking
extends Control

signal play_pressed
signal restart_pressed

@export var hackable_objects_methods : Dictionary
var object_button = preload("res://scenes/game_hacking/object_button.tscn")


func _on_play_button_pressed() -> void:
	play_pressed.emit()


func _on_restart_button_pressed() -> void:
	restart_pressed.emit()


func replace_object_buttons(_hackable_objects_methods : Dictionary) -> void:
	hackable_objects_methods = _hackable_objects_methods
	print(hackable_objects_methods)
	
	var container = $HBoxContainer/Objects/VBoxContainer
	for i in container.get_children():
		i.queue_free()
	await get_tree().process_frame
	
	for object_id in hackable_objects_methods.keys():
		var button = object_button.instantiate()
		button.get_node("RichTextLabel").text = object_id
		button.pressed.connect(func(): _on_object_button_pressed(object_id))
		container.add_child(button)


func _on_object_button_pressed(object_id: String) -> void:
	%Editor.open_editor_for(object_id)
