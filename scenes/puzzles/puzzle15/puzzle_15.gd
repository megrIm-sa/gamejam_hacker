extends Control

signal game_win

@export var table_size : int = 3

var is_game_started : bool = false

var correct_slot_color : Color = Color.AQUAMARINE
var wrong_slot_color : Color = Color.RED
var element_scene = preload("res://scenes/puzzles/puzzle15/puzzle_15_element.tscn")


#func _ready():
	#start_new_game()


func start_new_game() -> void:
	$Puzzle15.columns = table_size
	
	for i in table_size**2:
		var element : Puzzle15Element = element_scene.instantiate()
		element.slot_clicked.connect(_on_slot_clicked)
		element.correct_id = i
		$Puzzle15.add_child(element)
		if i == table_size**2-1:
			element.is_empty = true
	
	for i in 150:
		_on_slot_clicked($Puzzle15.get_children()[randi_range(0, table_size**2 - 1)])
	
	for element in $Puzzle15.get_children():
		if element.get_index() == element.correct_id:
			element.self_modulate = correct_slot_color
		else:
			element.self_modulate = wrong_slot_color
	
	await get_tree().process_frame
	$Puzzle15.show()
	is_game_started = true


func stop_game() -> void:
	is_game_started = false
	for child in $Puzzle15.get_children():
		child.queue_free()
	$Puzzle15.hide()


func _on_slot_clicked(element : Puzzle15Element) -> void:
	if element.is_empty:
		return
	var empty_element = _find_empty_element()
	if _is_can_be_swapped(empty_element.get_index(), element.get_index()):
		_swap_elements(element, empty_element, is_game_started)


func _find_empty_element() -> Puzzle15Element:
	for element in $Puzzle15.get_children():
		if element.is_empty:
			return element
	return null


func _is_can_be_swapped(empty_element_index, element_index) -> bool:
	return (
		(abs(empty_element_index - element_index) 
		+ abs(element_index / table_size - empty_element_index / table_size) == 1) 
		or abs(empty_element_index - element_index) == table_size
	)


func _swap_elements(element : Puzzle15Element, empty_element, is_animated : bool = false):
	var temp = element.get_index()
	
	if is_animated:
		$AudioStreamPlayer.play()
		var tween : Tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(element, "position", empty_element.position, 0.1)
		await tween.finished
	
	$Puzzle15.move_child(element, empty_element.get_index())
	$Puzzle15.move_child(empty_element, temp)
	
	if element.get_index() == element.correct_id:
		element.self_modulate = correct_slot_color
	else:
		element.self_modulate = wrong_slot_color
	
	_check_game_win()


func _check_game_win():
	if !is_game_started:
		return
	
	for element in $Puzzle15.get_children():
		if element.get_index() != element.correct_id:
			return
	
	game_win.emit()
