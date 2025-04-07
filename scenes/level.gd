class_name Level
extends Node2D

signal level_finished

@export var hackable_objects : Dictionary
@export var hackable_objects_methods : Dictionary
@export var music : AudioStream
@export  var spawn_pos : Vector2 = Vector2.ZERO
@export var gravity_inverse_used : bool = false

@onready var distortion_timer : Timer = $DistortionTimer
var distortion_material : ShaderMaterial
var distorted : bool = false


func _ready() -> void:
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
