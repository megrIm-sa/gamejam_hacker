extends Interactive

@export var interactive_objects : Array[Interactive]
@export var activate_interactive : bool = true


func _ready() -> void:
	if !activated:
		$Sprite2D.frame = 0
	else:
		$Sprite2D.frame = 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		$TouchScreenButton.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		$TouchScreenButton.hide()


func _on_touch_screen_button_pressed() -> void:
	$AudioStreamPlayer2D.play()
	if !activated:
		activated = true
		$Sprite2D.frame = 1
		if activate_interactive:
			for interactive_object in interactive_objects:
				interactive_object.activate()
		else:
			for interactive_object in interactive_objects:
				interactive_object.deactivate()
	else:
		activated = false
		$Sprite2D.frame = 0
		if activate_interactive:
			for interactive_object in interactive_objects:
				interactive_object.deactivate()
		else:
			for interactive_object in interactive_objects:
				interactive_object.activate()
