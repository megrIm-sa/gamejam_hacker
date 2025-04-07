extends Entity

@export var direction : float


func _ready() -> void:
	await get_tree().process_frame


func _physics_process(delta: float) -> void:
	if direction:
		if direction >= 0:
			$Sprite2D.flip_h = false
		elif direction < 0:
			$Sprite2D.flip_h = true
		velocity.x = direction * speed
		state = States.WALKING

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.kill()
