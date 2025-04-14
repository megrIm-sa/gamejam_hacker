extends Control

var current_hackable_object : HackableObject


func default_editor() -> void:
	%DisplayedText.text = "Select an object to edit"
	for i in $HBoxContainer.get_children():
		%ObjectIcon.texture = null
		%ObjectCount.text = ""
		i.queue_free()
	await get_tree().process_frame


func open_editor_for(hackable_object : HackableObject) -> void:
	current_hackable_object = hackable_object
	%DisplayedText.text = "Editing: [color=yellow]" + hackable_object.id
	
	if hackable_object.icon != null:
		%ObjectIcon.texture = hackable_object.icon
		%ObjectIcon.rotation = deg_to_rad(hackable_object.icon_rotation)
		if hackable_object.node_paths.size() > 1:
			%ObjectCount.text = "x" + str(hackable_object.node_paths.size())
		else:
			%ObjectCount.text = ""
	
	var container = $HBoxContainer
	for i in container.get_children():
		if i is TextureRect:
			continue
		i.queue_free()
	await get_tree().process_frame
	
	for method in hackable_object.method_names:
		var button = Button.new()
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.text = method
		button.pressed.connect(_on_call_pressed.bind(method))
		
		container.add_child(button)


func _on_call_pressed(method_name : String) -> void:
	if current_hackable_object == null:
		push_error("Object not selected!")
		return
	
	%AudioStreamPlayer.play()
	get_tree().current_scene.get_node("LevelManager").hack_object(current_hackable_object, method_name)
