extends Node2D

@export var laser_end_pos1: Vector2
@export var laser_end_pos2: Vector2

var health : int = 4
var agent_scene = preload("res://objects/entity/agent/agent.tscn")
var current_attack : int = 0
var attacks : Array[Callable] = [_spawn_agents, _shoot_laser]


func _ready() -> void:
	$AttackTimer.timeout.connect(_attack)
	material.set("shader_parameter/progress", 0.0)
	

func _process(delta: float) -> void:
	if !$AttackTimer.is_stopped():
		var player = $"..".game_2d.player
		if is_instance_valid(player):
			if position.direction_to(player.position).x < -0.2:
				$Sprite2D.flip_h = true
			elif position.direction_to(player.position).x > 0.2:
				$Sprite2D.flip_h = false


func _attack() -> void:
	if health <= 0:
		return
	print("attack")
	attacks[current_attack].call()
	current_attack += 1
	if current_attack >= attacks.size():
		current_attack = 0


func _shoot_laser() -> void:
	$Sprite2D.frame = 2
	$AnimationPlayer.current_animation = "RESET"
	await get_tree().create_timer(2, false).timeout
	
	var left_laser = $LaserLineLeft
	var right_laser = $LaserLineRight
	
	left_laser.visible = true
	right_laser.visible = true
	left_laser.clear_points()
	right_laser.clear_points()
	
	var left_origin : Vector2
	var right_origin : Vector2
	var eye_offset = Vector2(0, 16)
	
	var end1 = laser_end_pos1
	var end2 = laser_end_pos2
	if $Sprite2D.flip_h:
		end1.x *= -1
		end2.x *= -1
		left_origin = position - Vector2(eye_offset.x + 16, eye_offset.y)
		right_origin = position + Vector2(eye_offset.x + 4, -eye_offset.y)
	else:
		left_origin = position - Vector2(eye_offset.x + 4, eye_offset.y)
		right_origin = position + Vector2(eye_offset.x + 16, -eye_offset.y)
	
	left_laser.add_point(left_origin)
	left_laser.add_point(end1)

	right_laser.add_point(right_origin)
	right_laser.add_point(end1)

	var tween = create_tween()
	tween.tween_method(func(p: Vector2):
		if left_laser.get_point_count() >= 2:
			left_laser.set_point_position(1, p)
			_check_laser_hit(left_origin, p)
		if right_laser.get_point_count() >= 2:
			right_laser.set_point_position(1, p)
			_check_laser_hit(right_origin, p)
	, end1, end2, 3.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	
	left_laser.visible = false
	right_laser.visible = false
	$Sprite2D.frame = 0
	$AnimationPlayer.current_animation = "flying"
	$AttackTimer.start()



func _check_laser_hit(from: Vector2, to: Vector2) -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	
	if result and result.has("collider") and result.collider is Player:
		var player = result.collider as Player
		if is_instance_valid(player):
			player.kill()


func _spawn_agents() -> void:
	$Sprite2D.frame = 1
	for i in 2:
		_spawn_agent()
		await get_tree().create_timer(1, false).timeout
	await get_tree().create_timer(.5, false).timeout
	$Sprite2D.frame = 0
	$AttackTimer.start()


func _spawn_agent() -> void:
	var agent : Agent = agent_scene.instantiate()
	agent.position = position
	agent.stop_time = randf_range(0, 1)
	get_parent().add_child(agent)
	await get_tree().create_timer(1.0, false).timeout
	agent.position_x1 = -248
	agent.position_x2 = 248
	agent.moving_to_pos1 = [true, false].pick_random()


func damage() -> void:
	health -= 1
	print((4-health)/40.0)
	material.set("shader_parameter/progress", (4-health)/40.0)
	if health <= 0:
		await get_tree().create_timer(2, false).timeout
		get_parent().level_finished.emit()
