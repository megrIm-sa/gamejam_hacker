class_name Level
extends Node2D

signal level_finished

@export var hackable_objects : Dictionary
@export var hackable_objects_methods : Dictionary
@export var music : AudioStream
@export  var spawn_pos : Vector2 = Vector2.ZERO
@export var gravity_inverse_used : bool = false
@export var camera_zoom : float = 2
@export var camera_offset : Vector2 = Vector2(0, -16)

@onready var distortion_timer : Timer = $DistortionTimer
var distortion_material : ShaderMaterial
var distorted : bool = false
var game_2d : Game2D


func _ready() -> void:
	game_2d.get_node("Camera2D").zoom = Vector2(camera_zoom, camera_zoom)
	game_2d.get_node("Camera2D").camera_offset = camera_offset
	
	
	if distortion_timer:
		distortion_material = ShaderMaterial.new()
		distortion_material.shader = preload("res://objects/interactive/distortion.gdshader")
		distortion_timer.timeout.connect(_on_distortion_timer)
	
	for i in hackable_objects.values():
		if typeof(i) == TYPE_ARRAY:
			for path in i:
				if typeof(path) == TYPE_NODE_PATH and has_node(path):
					var obj = get_node(path)
					obj.material = distortion_material
		else:
			var obj = get_node(i)
			obj.material = distortion_material


func _on_distortion_timer() -> void:
	if !distorted:
		distortion_material.set("shader_parameter/animated", true)
		await get_tree().create_timer(0.4).timeout
		distortion_material.set("shader_parameter/animated", false)
	else:
		distortion_material.set("shader_parameter/animated", false)
