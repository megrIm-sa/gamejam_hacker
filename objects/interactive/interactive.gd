class_name Interactive
extends Node2D

@export var sound_distance = 320
@export var activated : bool = true


func _enter_tree() -> void:
	if has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.max_distance = sound_distance


func deactivate() -> void:
	activated = false


func activate() -> void:
	activated = true
