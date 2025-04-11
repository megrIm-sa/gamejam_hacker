extends CanvasLayer


func _enter_tree() -> void:
	show()


func _ready() -> void:
	WebBus.ready()
	hide()
