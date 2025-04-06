extends Interactive


func _ready() -> void:
	if activated:
		$Sprite2D.self_modulate = Color.WHITE
		$CollisionShape2D.disabled = false
	else:
		$Sprite2D.self_modulate = Color.DIM_GRAY
		$CollisionShape2D.disabled = true


func activate() -> void:
	super.activate()
	$Sprite2D.self_modulate = Color.WHITE
	$CollisionShape2D.disabled = false
	$AudioStreamPlayer2D.play()


func deactivate() -> void:
	super.deactivate()
	$Sprite2D.self_modulate = Color.DIM_GRAY
	$CollisionShape2D.disabled = true
	$AudioStreamPlayer2D.play()
