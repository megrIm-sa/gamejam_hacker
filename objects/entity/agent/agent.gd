class_name Agent
extends Entity

@export var stop_time : float = 2.0
@export var position_x1 : float
@export var position_x2 : float

var moving_to_pos1 : bool = true


func _physics_process(delta: float) -> void:
	var on_floor : bool = is_on_floor()
	if !on_floor:
		if velocity.length() <= 1000:
			velocity += get_gravity() * delta
	
	#if !$Timer.is_stopped():
		#return
	
	var direction : float
	if moving_to_pos1:
		direction = -1
	else:
		direction = 1
	if direction:
		if direction >= 0:
			$Sprite2D.flip_h = false
		elif direction < 0:
			$Sprite2D.flip_h = true
		if $Timer.is_stopped():
			velocity.x = direction * speed
			if on_floor:
				state = States.WALKING
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if on_floor:
			state = States.IDLE
	
	if $Timer.is_stopped():
		if moving_to_pos1:
			if abs(position_x1 - position.x) <= 16:
				moving_to_pos1 = false
				$Timer.start(stop_time)
				state = States.IDLE
		else:
			if abs(position_x2 - position.x) <= 16:
				moving_to_pos1 = true
				$Timer.start(stop_time)
				state = States.IDLE
	
	move_and_slide()


func kill() -> void:
	$AudioStreamPlayer2D.play()
	super.kill()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.kill()
