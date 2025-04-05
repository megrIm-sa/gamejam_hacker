class_name Interactive
extends Node2D

@export var activated : bool = true


func deactivate() -> void:
	activated = false


func activate() -> void:
	activated = true
