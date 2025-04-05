extends Control

signal game_win

var colors : Dictionary = { 
	0: [ Color(0, 0.55, 0.55), Color(0, 0.88, 0.88) ], 
	1: [ Color(0.66, 0.66, 0), Color(1, 1, 0) ],  
	2: [ Color(0.11, 0.66, 0), Color(0, 1, 0) ],  
	3: [ Color(0.66, 0, 0), Color(1, 0, 0) ],  
}

var sequence_sizes : Array = [3, 4, 5]
var current_sequence_index : int = 0
var blocked : bool = true
var sequence : Array[int]
var player_input : int = 0
var is_game_running : bool = false


func _ready() -> void:
	for i in $Simon.get_child_count():
		$Simon.get_child(i).pressed.connect(_try_press_element.bind(i))
		$Simon.get_child(i).self_modulate = colors[i][0]
	# start_new_game()


func start_new_game() -> void:
	is_game_running = true
	current_sequence_index = 0
	$Label.text = str(current_sequence_index) + "/" + str(sequence_sizes.size())
	_create_sequence(sequence_sizes[current_sequence_index])


func stop_game() -> void:
	is_game_running = false
	blocked = true
	sequence.clear()
	player_input = 0
	current_sequence_index = 0


func _create_sequence(sequence_size : int) -> void:
	blocked = true
	await get_tree().create_timer(1).timeout
	
	if !is_game_running:
		return
	
	sequence.clear()
	player_input = 0
	
	for i in sequence_size:
		sequence.append(randi_range(0, 3))
	
	for i in sequence:
		_on_element_pressed(i)
		await get_tree().create_timer(0.6).timeout
	
	if is_game_running:
		blocked = false


func _on_element_pressed(index : int) -> void:
	if !is_game_running:
		return

	$Simon.get_child(index).self_modulate = colors[index][1]
	match index:
		0:
			$AudioStreamPlayer.pitch_scale = 1
		1:
			$AudioStreamPlayer.pitch_scale = 1.122
		2:
			$AudioStreamPlayer.pitch_scale = 1.260
		3:
			$AudioStreamPlayer.pitch_scale = 1.335
	$AudioStreamPlayer.play()
	await get_tree().create_timer(0.3).timeout
	$Simon.get_child(index).self_modulate = colors[index][0]


func _try_press_element(index : int) -> void:
	if blocked or !is_game_running or player_input >= sequence.size():
		return
	
	_on_element_pressed(index)
	
	if index == sequence[player_input]:
		player_input += 1
		if player_input >= sequence.size():
			current_sequence_index += 1
			$Label.text = str(current_sequence_index) + "/" + str(sequence_sizes.size())
			if current_sequence_index < sequence_sizes.size():
				_create_sequence(sequence_sizes[current_sequence_index])
			else:
				is_game_running = false
				game_win.emit()
	else:
		$AudioStreamPlayer.pitch_scale = 0.5
		$AudioStreamPlayer.play()
		await get_tree().create_timer(0.5).timeout
		if is_game_running:
			start_new_game()
