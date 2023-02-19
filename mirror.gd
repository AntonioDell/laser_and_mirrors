extends Node2D


@onready var _rotate_component: RotateComponent = $RotateComponent


func _on_rotation_registered(rotate_amount: float):
	rotation += rotate_amount


func _on_selected():
	_rotate_component.is_rotation_enabled = true


func _on_deselected():
	_rotate_component.is_rotation_enabled = false
