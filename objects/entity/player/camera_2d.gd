extends Camera2D

@export var follow_player : bool = true

var camera_offset : Vector2

func _process(delta: float) -> void:
	if follow_player:
		if is_instance_valid($"..".player):
			position =  $"..".player.position + camera_offset *  $"..".player.gravity
