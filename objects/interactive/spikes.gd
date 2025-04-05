class_name Spikes
extends Interactive


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.kill()


func activate() -> void:
	super.activate()
	$Area2D.monitoring = false
	$AnimationPlayer.play("activate")


func deactivate() -> void:
	super.deactivate()
	$Area2D.monitoring = false
	$AnimationPlayer.play("deactivate")
