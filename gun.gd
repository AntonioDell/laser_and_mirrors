extends Node2D


@export var rotation_speed := 90.0


func _physics_process(delta):
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
