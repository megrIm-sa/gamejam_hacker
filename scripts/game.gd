extends Node

var tween : Tween


func _ready() -> void:
	%Game2D.show_crt_effect(true)
	set_pause_subtree(%Game2D, true)
	set_pause_subtree(%GameHacking, true)
	
	%GameHacking.play_pressed.connect(_show_game2d)
	%GameHacking.restart_pressed.connect(restart)
	%Game2D.hack_pressed.connect(_show_game_hacking)
	
	_show_game2d()


func _show_game2d() -> void:
	%Game3D.show()
	set_pause_subtree(%GameHacking, true)
	%GameHacking.reparent($Game3D/Monitor2/SubViewport)
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Game3D/Camera3D, "fov", 75, 0.25)
	tween.tween_property($Game3D/Camera3D, "position", Vector3(-3.5, 0, 3), 0.25)
	tween.parallel().tween_property($Game3D/Camera3D, "rotation", Vector3(0, deg_to_rad(100), 0), 0.25)
	tween.tween_property($Game3D/Camera3D, "fov", 45, 0.3)
	
	await tween.finished
	set_pause_subtree(%Game2D, false)
	%Game3D.hide()
	%Game2D.show_crt_effect(false)
	%Game2D.reparent($".")


func _show_game_hacking() -> void:
	%Game3D.show()
	set_pause_subtree(%Game2D, true)
	%Game2D.reparent($Game3D/Monitor1/SubViewport)
	%Game2D.show_crt_effect(true)
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Game3D/Camera3D, "fov", 75, 0.25)
	tween.tween_property($Game3D/Camera3D, "position", Vector3(-3.5, 0, -3), 0.25)
	tween.parallel().tween_property($Game3D/Camera3D, "rotation", Vector3(0, deg_to_rad(80), 0), 0.25)
	tween.tween_property($Game3D/Camera3D, "fov", 45, 0.3)
	
	await tween.finished
	set_pause_subtree(%GameHacking, false)
	%Game3D.hide()
	%GameHacking.reparent($".")


func set_pause_subtree(root: Node, pause: bool) -> void:
	var process_setters = [
		"set_process",
		"set_physics_process",
		"set_process_input",
		"set_process_unhandled_input",
		"set_process_unhandled_key_input",
		"set_process_shortcut_input",
	]
	
	for setter in process_setters:
		root.propagate_call(setter, [!pause])


func restart() -> void:
	%Game3D.show()
	set_pause_subtree(%GameHacking, true)
	%GameHacking.reparent($Game3D/Monitor2/SubViewport)
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Game3D/Camera3D, "fov", 75, 0.25)
	tween.tween_property($Game3D/Camera3D, "position", Vector3(0, 0, 0), 0.25)
	tween.parallel().tween_property($Game3D/Camera3D, "rotation", Vector3(0, deg_to_rad(90), 0), 0.25)
	
	await tween.finished
	%LevelManager.restart_level()
	_show_game2d()
