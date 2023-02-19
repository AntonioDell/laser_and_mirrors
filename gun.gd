extends Node2D


@export var rotation_speed := 90.0

var _mouse_pos: Vector2
var _original_angle: float
var _target_angle: float
var _rotation_progress = 0.0


func _physics_process(delta):
	#_follow_mouse(delta)
	_rotate_gun(delta)


func _rotate_gun(delta):
	var rotate_counter_clockwise_pressed = Input.is_action_pressed("rotate_counter_clockwise")
	var rotate_clockwise_pressed = Input.is_action_pressed("rotate_clockwise")
	if rotate_counter_clockwise_pressed and rotate_clockwise_pressed:
		return
	if not rotate_counter_clockwise_pressed and not rotate_clockwise_pressed: 
		return
	
	var direction = Vector2.LEFT if rotate_counter_clockwise_pressed else Vector2.RIGHT 
	rotation += direction.x * delta * deg_to_rad(rotation_speed)


func _follow_mouse(delta):
	if _mouse_pos != get_global_mouse_position():
		_mouse_pos = get_global_mouse_position()
		_original_angle = rotation
		_target_angle = global_position.angle_to_point(_mouse_pos)
		_rotation_progress = 0
	if _rotation_progress < 1.0:
		_rotation_progress += delta * rotation_speed
		rotation = lerp_angle(_original_angle, _target_angle, ease(_rotation_progress, .5))
