extends Area2D

@export var unlock_id : String


func _on_body_entered(body: Node2D) -> void:
	if !body is Player:
		return
	
	for i in $"..".hackable_objects as Array[HackableObject]:
		if i.id == unlock_id:
			i.unlocked = true
