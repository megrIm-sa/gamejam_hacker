extends Spikes

@export var time : float = 1.0

@onready var timer : Timer = $Timer

var spikes_active : bool = true


func _ready() -> void:
	timer.wait_time = time
	timer.start()
	timer.timeout.connect(_on_timeout)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.kill()


func _on_timeout() -> void:
	if spikes_active:
		$AnimationPlayer.play("deactivate")
		$Area2D.monitoring = false
		spikes_active = false
	else:
		$AnimationPlayer.play("activate")
		$Area2D.monitoring = true
		spikes_active = true
