extends Node

var tween : Tween


func _ready() -> void:
	#%Game2D.pause_mode = Node.PAUSE_MODE_PROCESS
	#%GameHacking.pause_mode = Node.PAUSE_MODE_PROCESS
	#$Menu.pause_mode = Node.PAUSE_MODE_PROCESS

	%Game2D.show_crt_effect(true)
	get_tree().paused = true

	%GameHacking.play_pressed.connect(_show_game2d)
	%GameHacking.restart_pressed.connect(restart)
	%GameHacking.menu_pressed.connect(_show_menu)
	%Game2D.hack_pressed.connect(_show_game_hacking)


func _show_game2d() -> void:
	$Menu.hide()
	%Game3D.show()
	get_tree().paused = true
	%GameHacking.reparent($Game3D/Monitor2/SubViewport)

	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Game3D/Camera3D, "fov", 75, 0.25)
	tween.tween_property($Game3D/Camera3D, "position", Vector3(-3.5, 0, 3), 0.25)
	tween.parallel().tween_property($Game3D/Camera3D, "rotation", Vector3(0, deg_to_rad(100), 0), 0.25)
	tween.tween_property($Game3D/Camera3D, "fov", 45, 0.3)

	await tween.finished
	print("unpause")
	get_tree().paused = false
	%Game3D.hide()
	%Game2D.show_crt_effect(false)
	%Game2D.reparent(self)


func _show_game_hacking() -> void:
	%Game3D.show()
	get_tree().paused = true
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
	get_tree().paused = false
	%Game3D.hide()
	%GameHacking.reparent(self)


func _show_menu() -> void:
	%Game3D.show()
	get_tree().paused = true
	%GameHacking.reparent($Game3D/Monitor2/SubViewport)

	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Game3D/Camera3D, "fov", 75, 0.25)
	tween.tween_property($Game3D/Camera3D, "position", Vector3(0, 0, 0), 0.25)
	tween.parallel().tween_property($Game3D/Camera3D, "rotation", Vector3(0, deg_to_rad(90), 0), 0.25)

	await tween.finished
	$Menu.show()


func restart() -> void:
	%Game3D.show()
	get_tree().paused = true
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


func _on_credits_button_pressed() -> void:
	$Menu/Control/Credits.show()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_close_credits_button_pressed() -> void:
	$Menu/Control/Credits.hide()
