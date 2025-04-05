extends Spikes

@export var time : float = 1.0

@onready var timer : Timer = $Timer

#var spikes_active : bool = true


func _ready() -> void:
	timer.wait_time = time
	timer.start()
	timer.timeout.connect(_on_timeout)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.kill()


func _on_timeout() -> void:
	if $Area2D.monitoring:
		$AnimationPlayer.play("deactivate")
		$Area2D.monitoring = false
		#spikes_active = false
	else:
		$AnimationPlayer.play("activate")
		#spikes_active = true


func _on_activate() -> void:
	$Area2D.monitoring = true
	$AudioStreamPlayer2D.play()
