extends Interactive

@export var speed : float = 50
@export var move_time : float = 2
@export var laser_time : float = 2
@export var position_x1 : float
@export var position_x2 : float

#var laser_active : bool = false
var moving_to_pos1 : bool = true


func _ready() -> void:
	$MoveTimer.wait_time = move_time
	$LaserTimer.wait_time = move_time
	$LaserTimer.timeout.connect(_on_timeout)
	
	if activated:
		activate()
	else:
		deactivate()


func _physics_process(delta: float) -> void:
	print($LaserTimer.is_stopped())
	if !$MoveTimer.is_stopped():
		return
	
	if moving_to_pos1:
		position.x -= speed * delta 
		if abs(position_x1 - position.x) <= 16:
			moving_to_pos1 = false
			$MoveTimer.start()
	else:
		position.x += speed * delta 
		if abs(position_x2 - position.x) <= 16:
			moving_to_pos1 = true
			$MoveTimer.start()


func _on_timeout() -> void:
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
	$LaserTimer.start()
	$AnimationPlayer.play("activate")
	$AnimationPlayer.queue("idle")
	$AudioStreamPlayer2D.play()


func deactivate() -> void:
	$LaserTimer.stop()
	$AnimationPlayer.play("deactivate")


func on_activate() -> void:
	#laser_active = true
	$Area2D.monitoring = true


func on_deactivate() -> void:
	#laser_active = false
	$Area2D.monitoring = false
