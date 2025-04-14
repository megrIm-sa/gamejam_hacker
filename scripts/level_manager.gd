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
	game_hacking.level_manager = self
	current_level_index = SaveSystem.get_var("level", 0)
	load_level(current_level_index)
	game_2d.restart_level.connect(restart_level)


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
	game_hacking.replace_object_buttons(level.hackable_objects)



func next_level() -> void:
	if current_level_index >= levels.size()-1:
		current_level_index = 0
	else:
		current_level_index += 1
	load_level(current_level_index)


func restart_level() -> void:
	load_level(current_level_index)


func hack_object(hackable_object : HackableObject, method_name : String, args : Array = []) -> void:
	if not game_2d:
		push_error("Game2D is not initialized.")
		return
	
	var level_2d = game_2d.level
	
	for path in hackable_object.node_paths:
		if typeof(path) == TYPE_NODE_PATH and level_2d.has_node(path):
			var obj = level_2d.get_node(path)
			if obj.has_method(method_name):
				obj.callv(method_name, args)
			else:
				push_error("Object at path '%s' does not have method '%s'" % [path, method_name])
		else:
			push_error("Invalid NodePath in array for object '%s'" % hackable_object.id)

	emit_signal("object_hacked", hackable_object.id, method_name)
