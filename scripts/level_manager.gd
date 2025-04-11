class_name LevelManager
extends Node

signal object_hacked(object_id: String, method_name: String)

@export var game_2d : Game2D
@export var game_hacking : GameHacking
@export var levels : Array[PackedScene]

var current_level_index : int


func _ready() -> void:
	#SaveSystem.set_var("level", 0)
	#SaveSystem.save()
	WebBus.ad_closed.connect(_ad_closed)
	WebBus.ad_error.connect(_ad_error)
	WebBus.ad_started.connect(_ad_started)
	$"../Menu/Control/LanguageButton".locale_changeed.connect(_on_locale_change)
	
	game_hacking.level_manager = self
	current_level_index = SaveSystem.get_var("level", 0)
	load_level(current_level_index)
	game_2d.restart_level.connect(restart_level)


func _ad_started():
	AudioServer.set_bus_mute(0, true)


func _ad_closed():
	AudioServer.set_bus_mute(0, false)
	get_tree().paused = false


func _ad_error():
	push_warning("ad_error")
	AudioServer.set_bus_mute(0, false)
	get_tree().paused = false


func _on_locale_change() -> void:
	if game_2d.level:
		game_hacking.replace_object_buttons(game_2d.level.hackable_objects_methods)



func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode in range(KEY_0, KEY_9+1):
			var index : int = event.keycode - KEY_0
			if index < levels.size():
				load_level(index)


func load_level(level_index : int) -> void:
	print("load level")
	current_level_index = level_index
	SaveSystem.set_var("level", level_index)
	SaveSystem.save()
	var level : Level = levels[level_index].instantiate() as Level
	level.level_finished.connect(next_level)
	%MusicPlayer.stream = level.music
	%MusicPlayer.play()
	game_2d.new_level(level)
	game_hacking.replace_object_buttons(level.hackable_objects_methods)


func next_level() -> void:
	WebBus.show_ad()
	if current_level_index >= levels.size()-1:
		current_level_index = 0
	else:
		current_level_index += 1
	load_level(current_level_index)


func restart_level() -> void:
	load_level(current_level_index)


func hack_object(object_id: String, method_name: String, args: Array = []) -> void:
	if not game_2d:
		push_error("Game2D is not initialized.")
		return
	
	var level_2d = game_2d.level
	
	var objects: Dictionary = level_2d.hackable_objects
	
	if not objects.has(object_id):
		push_error("Object '%s' not found in hackable_objects." % object_id)
		return
	
	var entry = objects[object_id]
	
	if typeof(entry) == TYPE_ARRAY:
		for path in entry:
			if typeof(path) == TYPE_NODE_PATH and level_2d.has_node(path):
				var obj = level_2d.get_node(path)
				if obj.has_method(method_name):
					obj.callv(method_name, args)
				else:
					push_error("Object at path '%s' does not have method '%s'" % [path, method_name])
			else:
				push_error("Invalid NodePath in array for object '%s'" % object_id)
	else:
		if typeof(entry) != TYPE_NODE_PATH or not level_2d.has_node(entry):
			push_error("Invalid NodePath for object '%s'" % object_id)
			return
		var obj = level_2d.get_node(entry)
		if not obj.has_method(method_name):
			push_error("Method '%s' not found on object '%s'" % [method_name, object_id])
			return
		obj.callv(method_name, args)

	emit_signal("object_hacked", object_id, method_name)
