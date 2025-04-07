class_name BossRunnerLevel
extends Level


@export var player_speed : float = 100
@export var boss : Entity

var player : Player
@export var boss_base_speed: float = 150
@export var boss_max_speed: float = 600
@export var speed_change_rate: float = 20


func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	player = game_2d.player
	if is_instance_valid(player):
		player.speed = player_speed
		player.scale.x = -1
		player.can_move = false
		player.killed.connect(func(): game_2d.restart_level.emit())


func _process(delta: float) -> void:
	if not is_instance_valid(player) or not is_instance_valid(boss):
		return
	
	var distance = player.global_position.x - boss.global_position.x
	
	if distance > 400:
		boss.speed = min(boss.speed + speed_change_rate * delta, boss_max_speed)
	else:
		boss.speed = max(boss.speed - speed_change_rate * 10 * delta, boss_base_speed)
	print(boss.speed )


func _unfroze_player() -> void:
	player.scale.x = 1
	player.can_move = true
