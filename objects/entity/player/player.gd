class_name Player
extends Entity

const JUMP_VELOCITY = -300.0

@export var immortal : bool = false

@onready var coyote_timer: Timer = $CoyoteTimer

var time_in_air : float = 0
var last_velocity : Vector2
var in_knockback : bool = false
var knockback : float = 0
var can_move : bool = true

var gravity : float = 1
var first_time_spawner = true


func _ready() -> void:
	animation_player.play("idle")
	if !first_time_spawner:
		set_physics_process(false)
		melt(0, 0.8)
		await get_tree().create_timer(.8).timeout
		set_physics_process(true)
	spawned.emit()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_1:
		change_gravity()


func _physics_process(delta: float) -> void:
	if !can_move:
		return
	
	var on_floor : bool = is_on_floor()
	if !on_floor:
		if velocity.length() <= 1000:
			velocity += gravity * get_gravity() * delta * (1 + time_in_air)
		
		state = States.JUMPING
		
		if velocity.y > 0:
			if time_in_air <= 1:
				time_in_air += .2 * delta
	elif last_velocity.length() >= 700:
		$"..".show_landing_effect(position)
	
	if Input.is_action_just_pressed("jump") and (on_floor or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY * gravity

	var direction := Input.get_axis("left", "right")
	if direction:
		if direction * gravity >= 0:
			$Sprite2D.flip_h = false
		elif direction * gravity < 0:
			$Sprite2D.flip_h = true
		velocity.x = direction * speed + knockback
		if on_floor:
			time_in_air = 0
			state = States.WALKING
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if on_floor:
			time_in_air = 0
			state = States.IDLE
	
	last_velocity = velocity
	move_and_slide()
	
	if not in_knockback:
		knockback = lerp(knockback, 0.0, 0.15)
	if on_floor and !is_on_floor():
		coyote_timer.start()


func kill() -> void:
	if immortal:
		return
	$AudioStreamPlayer2D.play()
	super.kill()


func change_gravity() -> void:
	if gravity == 1:
		gravity = -1
		position.y -= 36
		rotation = PI
		up_direction = Vector2.DOWN
	else:
		gravity = 1
		position.y += 36
		rotation = 0
		up_direction = Vector2.UP
