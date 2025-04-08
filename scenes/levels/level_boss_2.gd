extends Level


func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	var player = game_2d.player
	if is_instance_valid(player):
		player.killed.connect(func(): game_2d.restart_level.emit())
