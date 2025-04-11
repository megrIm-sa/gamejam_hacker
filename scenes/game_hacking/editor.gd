extends Control

var current_object_id: String = ""

func _ready() -> void:
	match OS.get_name():
		"Web":
			%Output.hide()


func default_editor() -> void:
	$RichTextLabel.text = tr("UI_OBJECT_SELECT")
	for i in $HBoxContainer.get_children():
		i.queue_free()
	await get_tree().process_frame


func open_editor_for(object_id: String) -> void:
	current_object_id = object_id
	$RichTextLabel.text = tr("UI_OBJECT_SELECTED") + tr(object_id)
	
	var container = $HBoxContainer
	for i in container.get_children():
		i.queue_free()
	await get_tree().process_frame
	
	var methods = $"../../..".hackable_objects_methods[object_id]
	
	for method in methods:
		var button = Button.new()
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.text = method
		button.pressed.connect(_on_call_pressed.bind(method))
		
		container.add_child(button)


func _on_call_pressed(method_name : String) -> void:
	if current_object_id == "":
		push_error("Object not selected!")
		return

	%AudioStreamPlayer.play()
	get_tree().current_scene.get_node("LevelManager").hack_object(current_object_id, method_name)
