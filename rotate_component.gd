extends Node2D

## [rotate_amount] in radians
signal rotation_registered(rotate_amount: float)


@export var is_rotation_enabled := true
@export var rotation_speed := 50.0


func _physics_process(delta):
	if not is_rotation_enabled: return
	_process_rotation(delta)


func _process_rotation(delta):
	var rotate_counter_clockwise_pressed = Input.is_action_pressed("rotate_counter_clockwise")
	var rotate_clockwise_pressed = Input.is_action_pressed("rotate_clockwise")
	if rotate_counter_clockwise_pressed and rotate_clockwise_pressed:
		return
	if not rotate_counter_clockwise_pressed and not rotate_clockwise_pressed: 
		return
	
	var direction = Vector2.LEFT if rotate_counter_clockwise_pressed else Vector2.RIGHT 
	var rotation_amount = direction.x * delta * deg_to_rad(1.0) * rotation_speed
	emit_signal("rotation_registered", rotation_amount)
