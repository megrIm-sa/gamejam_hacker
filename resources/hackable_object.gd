class_name HackableObject
extends Resource

@export var id : String
@export var unlocked : bool = true
@export var node_paths : Array[NodePath]
@export var method_names : Array[String]

@export_group("Icon")
@export var icon : Texture2D
@export var icon_rotation : float
