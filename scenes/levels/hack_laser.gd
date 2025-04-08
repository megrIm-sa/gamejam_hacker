extends Node2D

var laser_ready : bool = false
var tween : Tween

func _ready() -> void:
	$ReadyTimer.timeout.connect(_laser_ready)


func _process(delta: float) -> void:
	$Wire.material.set("shader_parameter/progress", 1-$ReadyTimer.time_left/$ReadyTimer.wait_time)
	$Wire2.material.set("shader_parameter/progress", 1-$ReadyTimer.time_left/$ReadyTimer.wait_time)


func _laser_ready() -> void:
	laser_ready = true
	$BarrierStuff.material.set("shader_parameter/animated", true)


func activate() -> void:
	if !laser_ready:
		return
		
	laser_ready = false
	
	$BarrierStuff.material.set("shader_parameter/animated", false)
	$Laser.visible = true
	$CanvasModulate.color = Color(0, 1, 1)
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Laser, "modulate", Color(1, 1, 1, 1), 0.3)
	
	$"../Boss".damage()
	
	$ShootTimer.start()
	await $ShootTimer.timeout
	
	tween = create_tween()
	tween.tween_property($Laser, "modulate", Color(1, 1, 1, 0), 0.3)
	await tween.finished

	$Laser.visible = false
	$CanvasModulate.color = Color(1, 1, 1)
	$ReadyTimer.start()
	
