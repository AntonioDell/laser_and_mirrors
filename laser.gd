extends Node2D


enum CollisionAction {STOP_RAY, CONTINUE_RAY, REFLECT_RAY}


@export_flags_2d_physics var collision_mask
@export var max_length := 1000.0
@export var show_debug_line := false :
	set(new_value):
		show_debug_line = new_value
		$DebugLine.visible = show_debug_line


var _debug_line_points: PackedVector2Array
var _reflection_points: PackedVector2Array


func _physics_process(delta):
	_debug_line_points = PackedVector2Array()
	_reflection_points = PackedVector2Array()
	_cast_ray(global_position, Vector2.RIGHT.rotated(global_rotation))
	if $DebugLine.points != _debug_line_points:
		$DebugLine.points = _debug_line_points


func _process_collision(collider: Object, normal: Vector2, source: Vector2, point: Vector2) -> Dictionary:
	if collider is ReflectionComponent:
		var incoming_ray: Vector2 = point - source
		# r = d - 2(d*n)n
		var reflection: Vector2 = incoming_ray - 2 * incoming_ray.dot(normal) * normal
		return {"action": CollisionAction.REFLECT_RAY, "point": point, "direction": reflection.normalized()}
	elif collider is HurtboxComponent:
		collider.receive_damage()
		return {"action": CollisionAction.CONTINUE_RAY}
		
	return {"action": CollisionAction.STOP_RAY, "point": point}


func _cast_ray(source: Vector2, direction: Vector2):
	_debug_line_points.append(to_local(source))
	var space_state = get_world_2d().direct_space_state
	var ray_to = source + direction.normalized() * max_length
	var query := PhysicsRayQueryParameters2D.create(source, ray_to, collision_mask)
	query.hit_from_inside = false
	var result := space_state.intersect_ray(query)
	var collision_result := {"action": CollisionAction.CONTINUE_RAY}
	while not result.is_empty():
		collision_result = _process_collision(result.collider, result.normal, source, result.position)
		match(collision_result.action):
			CollisionAction.CONTINUE_RAY: 
				query.exclude.append(result.collider_id)
				result = space_state.intersect_ray(query)
			CollisionAction.STOP_RAY, CollisionAction.REFLECT_RAY: 
				break
	if collision_result.action == CollisionAction.REFLECT_RAY and not _reflection_points.has(collision_result.point):
		# ! Recursion !
		_reflection_points.append(collision_result.point)
		_cast_ray(collision_result.point, collision_result.direction)
	elif collision_result.action == CollisionAction.CONTINUE_RAY:
		_debug_line_points.append(to_local(ray_to))
	else:
		# Stop ray
		print("Stop")
		_debug_line_points.append(to_local(collision_result.point))

