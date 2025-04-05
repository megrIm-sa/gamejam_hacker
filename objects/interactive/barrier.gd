extends Interactive


func _ready() -> void:
	if activated:
		$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("deactivate")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if activated and body is Entity:
		var direction = global_position.direction_to(body.global_position)
		var force = direction.x * 800
		body.knockback = force
		body.in_knockback = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Entity:
		body.in_knockback = false


func activate() -> void:
	super.activate()
	$AnimationPlayer.play("idle")
	


func deactivate() -> void:
	super.deactivate()
	$AnimationPlayer.play("deactivate")
