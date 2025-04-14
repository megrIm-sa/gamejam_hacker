extends Control

@onready var dialog_text : RichTextLabel = $DialogText
@export var char_speed := 0.04
@export var pause_dot := 0.3
@export var pause_comma := 0.15
@export var pause_exclaim := 0.25
@export var pause_question := 0.25
@export var read_delay := 2.0

var full_text := ""
var tween: Tween
var is_animating := false
var display_ratio := 0.0

# Для анимации окна
var show_height : float = 520
var hide_height : float = 648


func _ready() -> void:
	dialog_text.bbcode_enabled = true
	dialog_text.visible_ratio = 0.0
	modulate.a = 0.0


func show_dialog(text: String) -> void:
	print(text)
	full_text = text
	dialog_text.bbcode_text = full_text
	dialog_text.visible_ratio = 0.0
	display_ratio = 0.0
	is_animating = true
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position:y", show_height, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	
	tween.tween_callback(Callable(self, "_start_typing")).set_delay(0.5)


func _start_typing() -> void:
	_show_next_character()


func _show_next_character() -> void:
	if display_ratio >= 1.0:
		is_animating = false
		tween = create_tween()
		tween.tween_callback(Callable(self, "_hide_dialog")).set_delay(read_delay)
		return
	
	var visible_text = dialog_text.get_parsed_text()
	var index = floor(display_ratio * visible_text.length())
	var next_char = visible_text[index] if index < visible_text.length() else ""
	
	var delay := char_speed
	match next_char:
		".":
			delay += pause_dot
		",":
			delay += pause_comma
		"!", "?":
			delay += pause_exclaim
	
	display_ratio += 1.0 / visible_text.length()
	dialog_text.visible_ratio = display_ratio
	
	tween = create_tween()
	tween.tween_callback(Callable(self, "_show_next_character")).set_delay(delay)


func _hide_dialog() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_property(self, "position:y", hide_height, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	

func skip_text() -> void:
	if not is_animating:
		return
	if tween:
		tween.kill()
	dialog_text.visible_ratio = 1.0
	is_animating = false

	tween = create_tween()
	tween.tween_callback(Callable(self, "_hide_dialog")).set_delay(read_delay)
