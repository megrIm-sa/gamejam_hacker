extends Interactive

@export var time : float = 2
var laser_active : bool = false


func _ready() -> void:
	$Timer.wait_time = time
	$Timer.timeout.connect(_on_timeout)
	if activated:
		activate()
	else:
		deactivate()


func _on_timeout() -> void:
	if laser_active:
		$AnimationPlayer.play("deactivate")
	else:
		$AnimationPlayer.play("activate")
		$AnimationPlayer.queue("idle")
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if laser_active and body is Entity:
		body.kill()


func activate() -> void:
	$Timer.start()


func deactivate() -> void:
	$Timer.stop()
	$AnimationPlayer.play("deactivate")


func on_activate() -> void:
	laser_active = true


func on_deactivate() -> void:
	laser_active = false
	
