class_name Teleport
extends Node2D


@export var teleport_to : Teleport
var just_teleported : bool


func _on_area_2d_body_entered(body: Node2D) -> void:
	if teleport_to == null:
		push_warning("Second TP is null!")
		return
	
	if !just_teleported and body is Player:
		body.state = body.States.IDLE
		await get_tree().physics_frame
		body.melt(1, 0.3, Color(0,1,1))
		body.can_move = false
		await get_tree().create_timer(0.3).timeout
		body.position = teleport_to.position
		body.velocity = Vector2.ZERO
		teleport_to.just_teleported = true
		body.melt(0, 0.3, Color(0,1,1))
		await get_tree().create_timer(0.3).timeout
		body.can_move = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		just_teleported = false
