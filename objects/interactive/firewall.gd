extends Interactive

func _ready() -> void:
	if !activated:
		deactivate()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if activated and body is Player:
		body.kill()

func activate() -> void:
	super.activate()
	$Area2D.monitoring = true
	$AnimationPlayer.play("idle")


func deactivate() -> void:
	super.deactivate()
	$Area2D.monitoring = false
	$AnimationPlayer.play("deactivate")
