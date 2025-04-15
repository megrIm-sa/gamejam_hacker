extends Interactive


func unlock_gravity_inverse() -> void:
	super.activate()
	get_parent().get_parent().get_parent().show_gravity_button()
	for i in $"../..".hackable_objects as Array[HackableObject]:
		if i.id == "gravity_module":
			i.unlocked = false
