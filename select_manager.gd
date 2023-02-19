extends Node


var _select_nodes: Array[SelectComponent] = []
var _current_selected_index := 0


func register(node: SelectComponent):
	if _select_nodes.has(node): return
	_select_nodes.append(node)


func _unhandled_key_input(event):
	if Input.is_action_just_pressed("select_next"):
		_update_selection(true)
	elif Input.is_action_just_pressed("select_previous"):
		_update_selection(false)


func _update_selection(next: bool):
	_select_nodes[_current_selected_index].deselect()
	
	_current_selected_index += 1 if next else -1
	if _select_nodes.is_empty(): return
	if _current_selected_index < 0:
		_current_selected_index = _select_nodes.size() - 1
	elif _current_selected_index >= _select_nodes.size():
		_current_selected_index = 0
		
	_select_nodes[_current_selected_index].select() 
