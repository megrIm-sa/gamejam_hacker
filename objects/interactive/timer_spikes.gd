extends Spikes

@export var offset_time : float = 0
@export var time : float = 1.0

@onready var timer : Timer = $Timer

#var spikes_active : bool = true


func _ready() -> void:
	if activated:
		activate()
	else:
		deactivate()
	timer.timeout.connect(_on_timeout)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.kill()


func _on_timeout() -> void:
	timer.wait_time = time
	if $Area2D.monitoring:
		$AnimationPlayer.play("deactivate")
		#$Area2D.monitoring = false
		#spikes_active = false
	else:
		$AnimationPlayer.play("activate")
		#spikes_active = true


func activate() -> void:
	super.activate()
	$Timer.start(time + offset_time)


func deactivate() -> void:
	super.deactivate()
	$Timer.stop()


func _on_activate() -> void:
	super._on_activate()
