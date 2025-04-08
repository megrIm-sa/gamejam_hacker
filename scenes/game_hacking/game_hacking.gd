class_name GameHacking
extends Control

signal play_pressed
signal restart_pressed
signal menu_pressed


@export var hackable_objects_methods : Dictionary

var object_button = preload("res://scenes/game_hacking/object_button.tscn")
var level_manager : LevelManager
var output_textlabel = preload("res://scenes/game_hacking/rich_text_label.tscn")


func _ready() -> void:
	await get_tree().process_frame
	level_manager.object_hacked.connect(_add_to_output)


func _on_play_button_pressed() -> void:
	play_pressed.emit()
	%AudioStreamPlayer.play()


func _on_restart_button_pressed() -> void:
	restart_pressed.emit()
	%AudioStreamPlayer.play()


func _on_menu_button_pressed() -> void:
	menu_pressed.emit()
	%AudioStreamPlayer.play()


func replace_object_buttons(_hackable_objects_methods : Dictionary) -> void:
	%Editor.default_editor()
	
	for i in %OutputContainer.get_children():
		i.queue_free()
	
	hackable_objects_methods = _hackable_objects_methods
	
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
	%AudioStreamPlayer.play()


func _add_to_output(object_id: String, method_name: String) -> void:
	var output = output_textlabel.instantiate()
	output.text = "Method \"" + method_name + "\" executed on object \"" + object_id + "\""
	if %OutputContainer.get_child_count() > 0:
		%OutputContainer.get_child(%OutputContainer.get_child_count()-1).modulate = Color.WEB_GRAY
	%OutputContainer.add_child(output)
	await get_tree().process_frame
	%OutpuScroll.scroll_vertical = %OutpuScroll.get_v_scroll_bar().max_value
