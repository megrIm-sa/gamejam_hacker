extends Interactive

@export var speed : float = 50.0
@export var stop_time : float = 2.0
@export var position1 : Vector2
@export var position2 : Vector2

var moving_to_pos1 : bool = true


func _physics_process(delta: float) -> void:
	if !activated or !$Timer.is_stopped():
		return
	
	if moving_to_pos1:
		position += position.direction_to(position1) * speed * delta 
		if position.distance_squared_to(position1) < 4:
			moving_to_pos1 = false
			$Timer.start(stop_time)
	else:
		position += position.direction_to(position2) * speed * delta 
		if position.distance_squared_to(position2) < 4:
			moving_to_pos1 = true
			$Timer.start(stop_time)
