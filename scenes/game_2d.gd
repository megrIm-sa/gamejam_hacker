class_name Game2D
extends Node2D

signal hack_pressed

@export var level : Node2D
var player_scene = preload("res://objects/entity/player/player.tscn")
var player : Player


func _ready() -> void:
	$CanvasLayer/UI/GoToHackingButton.pressed.connect(hack_pressed.emit)


func spawn_player(pos : Vector2 = Vector2.ZERO, first_time : bool = false) -> void:
	player = player_scene.instantiate()
	player.killed.connect(_on_player_killed)
	player.spawned.connect(func(): $Camera2D.position_smoothing_enabled = false)
	player.first_time_spawner = first_time
	add_child(player)
	player.position = pos


func new_level(new_level : Level) -> void:
	if level:
		level.queue_free()
	delete_player()
	await get_tree().process_frame
	level = new_level
	if !level.gravity_inverse_used:
		$"CanvasLayer/UI/2DControls/GravityButton".hide()
	add_child(new_level)
	spawn_player(Vector2.ZERO, true)


func delete_player() -> void:
	if player:
		player.killed.disconnect(_on_player_killed)
		#$Camera2D.position_smoothing_enabled = true
		player.queue_free()


func _on_player_killed() -> void:
	player.killed.disconnect(_on_player_killed)
	$Camera2D.position_smoothing_enabled = true
	spawn_player(level.spawn_pos)


func show_landing_effect(pos : Vector2, reversed : bool = false) -> void:
	print(reversed)
	%LandingEffect.get_child(0).play("idle")
	%LandingEffect.flip_v = reversed
	if reversed:
		%LandingEffect.position = pos + Vector2(0, 48)
	else:
		%LandingEffect.position = pos
	%LandingEffect.show()


func show_crt_effect(show : bool) -> void:
	$Camera2D/MonitorEffect.visible = show
	$CanvasLayer.visible = !show


func show_gravity_button() -> void:
	$"CanvasLayer/UI/2DControls/GravityButton".show()
