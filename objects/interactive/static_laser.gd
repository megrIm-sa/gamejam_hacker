extends Interactive

@export var offset_time : float = 0
@export var time : float = 2


func _ready() -> void:
	if has_node("Timer"):
		$Timer.start(offset_time + time)
		$Timer.timeout.connect(_on_timeout)
	
	if activated:
		activate()
	else:
		deactivate()


func _on_timeout() -> void:
	if has_node("Timer"):
		$Timer.wait_time = time
	if $Area2D.monitoring:
		$AnimationPlayer.play("deactivate")
	else:
		$AnimationPlayer.play("activate")
		$AnimationPlayer.queue("idle")
		$AudioStreamPlayer2D.play()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.kill()


func activate() -> void:
	if has_node("Timer"):
		$Timer.start()
	else:
		_on_timeout()


func deactivate() -> void:
	if has_node("Timer"):
		$Timer.stop()
	if $Area2D.monitoring:
		$AnimationPlayer.play("deactivate")
	elif activated:
		$AnimationPlayer.play("activate")
		$AnimationPlayer.queue("idle")
		$AudioStreamPlayer2D.play()


func on_activate() -> void:
	$Area2D.monitoring = true


func on_deactivate() -> void:
	$Area2D.monitoring = false
