extends Interactive

@export var interactive_objects : Array[Interactive]
@export var activate_interactive : bool = true
@export_file(".tscn") var minigame_scene

var minigame
var tween : Tween 
var player_canvas_layer : CanvasLayer


func _ready() -> void:
	if minigame_scene == null:
		return
	
	player_canvas_layer = get_parent().get_parent().get_parent().get_node("CanvasLayer")
	minigame = load(minigame_scene).instantiate()
	$CanvasLayer/Minigame.add_child(minigame)
	minigame.game_win.connect(activate)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !activated and body is Player:
		$TouchScreenButton.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if !activated and body is Player:
		_close_minigame()
		$TouchScreenButton.hide()


func _on_touch_screen_button_pressed() -> void:
	if minigame_scene == null:
		activate()
		return
	$TouchScreenButton.hide()
	$CanvasLayer.show()
	player_canvas_layer.hide()
	
	_tween_canvas(0)
	await tween.finished
	
	
	minigame.start_new_game()


func _close_minigame() -> void:
	if minigame_scene == null:
		return
	
	$TouchScreenButton.show()
	minigame.stop_game()
	
	_tween_canvas(1152)
	await tween.finished
	
	player_canvas_layer.show()
	$CanvasLayer.hide()


func activate() -> void:
	$AudioStreamPlayer2D.play()
	player_canvas_layer.show()
	super.activate()
	_tween_canvas(1152)
	await tween.finished
	$CanvasLayer.hide()
	$TouchScreenButton.hide()
	$AnimationPlayer.play("idle_deactivated")
	if activate_interactive:
		for interactive_object in interactive_objects:
			interactive_object.deactivate()
	else:
		for interactive_object in interactive_objects:
			interactive_object.activate()


func deactivate() -> void:
	$AudioStreamPlayer2D.play()
	player_canvas_layer.show()
	super.deactivate()
	$CanvasLayer.hide()
	$TouchScreenButton.hide()
	$AnimationPlayer.play("idle_activated")
	if !activate_interactive:
		for interactive_object in interactive_objects:
			interactive_object.activate()
	else:
		for interactive_object in interactive_objects:
			interactive_object.deactivate()


func _tween_canvas(y : float) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($CanvasLayer, "offset", Vector2(0, y), 0.5)
