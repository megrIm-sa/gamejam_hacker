class_name Game2D
extends Node2D

signal hack_pressed

@export var level : Node2D
var player_scene = preload("res://objects/entity/player/player.tscn")
var player : CharacterBody2D


func _ready() -> void:
	$CanvasLayer/UI/GoToHackingButton.pressed.connect(hack_pressed.emit)


func spawn_player(pos : Vector2 = Vector2.ZERO) -> void:
	player = player_scene.instantiate()
	player.position = pos
	call_deferred("add_child", player)
	player.killed.connect(_on_player_killed)
	player.spawned.connect(func(): $Camera2D.position_smoothing_enabled = false)


func new_level(new_level : Level) -> void:
	if level:
		level.queue_free()
	delete_player()
	await get_tree().process_frame
	level = new_level
	add_child(new_level)
	spawn_player()


func delete_player() -> void:
	if player:
		player.killed.disconnect(_on_player_killed)
		$Camera2D.position_smoothing_enabled = true
		player.queue_free()


func _on_player_killed() -> void:
	player.killed.disconnect(_on_player_killed)
	$Camera2D.position_smoothing_enabled = true
	spawn_player()


func show_landing_effect(pos : Vector2) -> void:
	%LandingEffect.get_child(0).play("idle")
	%LandingEffect.position = pos
	%LandingEffect.show()


func show_crt_effect(show : bool) -> void:
	$Camera2D/MonitorEffect.visible = show
	$CanvasLayer.visible = !show
