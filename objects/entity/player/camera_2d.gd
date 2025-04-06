extends Camera2D

@export var follow_player : bool = true


func _process(delta: float) -> void:
	if follow_player:
		if is_instance_valid($"..".player):
			position =  $"..".player.position + Vector2(0, -16) *  $"..".player.gravity
