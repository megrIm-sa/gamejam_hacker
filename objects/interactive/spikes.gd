class_name Spikes
extends Interactive


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.kill()


func activate() -> void:
	super.activate()
	$AnimationPlayer.play("activate")


func _on_activate() -> void:
	$Area2D.monitoring = true
	$AudioStreamPlayer2D.play()


func deactivate() -> void:
	super.deactivate()
	$AnimationPlayer.play("deactivate")


func _on_deactivate() -> void:
	$Area2D.monitoring = false
