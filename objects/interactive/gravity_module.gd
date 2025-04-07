extends Interactive


func unlock_gravity_inverse() -> void:
	super.activate()
	get_parent().get_parent().get_parent().show_gravity_button()
