extends Spikes

@export var offset_time : float = 0
@export var time : float = 1.0

@onready var timer : Timer = $Timer


func _ready() -> void:
	super._ready()
	timer.timeout.connect(_on_timeout)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.kill()


func _on_timeout() -> void:
	timer.wait_time = time
	if $Area2D.monitoring:
		$AnimationPlayer.play("deactivate")
	else:
		$AnimationPlayer.play("activate")


func activate() -> void:
	super.activate()
	$Timer.start(time + offset_time)


func deactivate() -> void:
	super.deactivate()
	$Timer.stop()


func _on_activate() -> void:
	super._on_activate()
