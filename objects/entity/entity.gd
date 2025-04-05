class_name Entity
extends CharacterBody2D


signal spawned
signal killed

@export var speed = 200.0

@onready var animation_player : AnimationPlayer = $AnimationPlayer

enum States { IDLE, WALKING, JUMPING }

var state : States = States.IDLE:
	set = _set_state
var melt_tween : Tween


func _ready() -> void:
	animation_player.play("idle")
	set_physics_process(false)
	melt(0, 0.8)
	await get_tree().create_timer(.8).timeout
	set_physics_process(true)
	spawned.emit()


func kill() -> void:
	velocity = Vector2.ZERO
	set_physics_process(false)
	melt(1, 0.8)
	await get_tree().create_timer(.8).timeout
	killed.emit()
	queue_free()


func melt(value : float, time : float, color : Color = Color.WHITE) -> void:
	if melt_tween:
		melt_tween.kill()
	melt_tween = create_tween()
	$Sprite2D.material.set("shader_parameter/animated", true)
	if color != Color.WHITE:
		$Sprite2D.material.set("shader_parameter/use_color", true)
		$Sprite2D.material.set("shader_parameter/color", color)
	else:
		$Sprite2D.material.set("shader_parameter/use_color", false)
	melt_tween.tween_property($Sprite2D.material, "shader_parameter/progress", value, time).set_trans(Tween.TRANS_CUBIC)
	await melt_tween.finished
	if value == 0:
		$Sprite2D.material.set("shader_parameter/animated", false)


func _set_state(new_state : States):
	if new_state == state:
		return
	
	state = new_state
	match state:
		States.IDLE:
			animation_player.play("idle")
			#print("idle")
		States.WALKING:
			animation_player.play("walking")
			#print("running")
		States.JUMPING:
			animation_player.play("jumping")
			#print("running")
