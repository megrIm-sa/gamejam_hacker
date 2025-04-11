extends TextureButton

signal locale_changeed

var languages = ["en", "ru"]
var flags = {
	"en": preload("res://assets/unitedkingdom.png"),
	"ru": preload("res://assets/russia.png"),
}


func _ready() -> void:
	_update_language()
	await WebBus.on_info_set
	TranslationServer.set_locale(WebBus.get_language())
	_update_language()
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	var next_lang = languages[(languages.find(TranslationServer.get_locale()) + 1) % languages.size()]
	
	TranslationServer.set_locale(next_lang)
	_update_language()


func _update_language() -> void:
	locale_changeed.emit()
	texture_normal = flags.get(TranslationServer.get_locale(), flags["ru"])
