extends Area2D

@export var typing_duration: float = 0.4

@onready var label = $Label
@onready var tween: Tween


func _ready():
	label.visible = false
	label.visible_characters = 0
	for i in get_overlapping_bodies():
		if i is Player:
			_on_body_entered(i)


func _on_body_entered(body: Node2D) -> void:
	if is_physics_processing() and body is Player:
		label.visible = true
		label.visible_characters = 0
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(label, "visible_characters", label.text.length(), typing_duration)


func _on_body_exited(body: Node2D) -> void:
	if is_physics_processing() and body is Player:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(label, "visible_characters", 0, typing_duration)
		await tween.finished
		label.visible = false
