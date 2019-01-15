extends Area2D

var height: float
export(float) var max_acceleration = -9.8


func _ready():
	height = shape_owner_get_shape(
		get_shape_owners()[0], 0).extents.y
	print(height)

func _on_BouyanceArea_body_entered(body):
	if not body is RigidBody2D:
		return
	else:
		if body.get("in_water") != null:
			body.in_water = true


func _on_BouyanceArea_body_exited(body):
	if not body is RigidBody2D:
		return
	else:
		if body.get("in_water") != null:
			body.in_water = false


func _physics_process(delta):
	for b in get_overlapping_bodies():
		if not b is RigidBody2D:
			continue
		var factor = get_height_percentage(b.global_position)
		b.apply_impulse(
			Vector2.ZERO,
			Vector2(
				0,
				max_acceleration * b.mass * factor
				)
			)

# This function returns 0 if at the surface, 1 if at the bottom of the float area
func get_height_percentage(obj_position: Vector2):
	var surface_position = global_position.y - height / 2.0
	var delta = obj_position.y - surface_position
	var norm = delta / height
	if norm > 0.7:
		print(norm)
	return clamp(norm + 0.4, 0.0, 1.0)
	