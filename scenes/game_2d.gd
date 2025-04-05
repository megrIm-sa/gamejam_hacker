extends Node2D

signal hack_pressed

var player_scene = preload("res://objects/entity/player/player.tscn")
var player : CharacterBody2D


func _ready() -> void:
	$CanvasLayer/UI/GoToHackingButton.pressed.connect(hack_pressed.emit)
	_spawn_player()


func _spawn_player(pos : Vector2 = Vector2.ZERO) -> void:
	player = player_scene.instantiate()
	player.position = pos
	call_deferred("add_child", player)
	player.killed.connect(_on_player_killed)
	player.spawned.connect(func(): $Camera2D.position_smoothing_enabled = false)


func _on_player_killed() -> void:
	player.killed.disconnect(_on_player_killed)
	$Camera2D.position_smoothing_enabled = true
	_spawn_player()


func show_landing_effect(pos : Vector2) -> void:
	%LandingEffect.get_child(0).play("idle")
	%LandingEffect.position = pos
	%LandingEffect.show()


func show_crt_effect(show : bool) -> void:
	$Camera2D/MonitorEffect.visible = show
	$CanvasLayer.visible = !show
