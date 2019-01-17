extends Node2D

var acceleration = 1000
var swim_acceleration = 198
var max_speed = 100
var climb_speed = 50
var step_size = 5
var feet_y = 32
var randomness = 3
var velocity = Vector2(0, 0)
var swim_time_left = 5

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if $RayCast2DWater.is_colliding(): # Uh, wet!
		swim_time_left -= delta
		velocity.x *= pow(0.4, delta)
		if swim_time_left > 0:
			velocity.y -= swim_acceleration * delta
		elif swim_time_left < -1:
			queue_free()
	
	if $RayCast2D.is_colliding(): # Can feel terrain, yay
		var direction = sign((randi() % 2 - 0.5) * randomness - $RayCast2D.get_collision_normal().x)
		
		# Try to climb
		if (!$RayCast2DLeftLook.is_colliding() and direction < 0) or (!$RayCast2DRightLook.is_colliding() and direction > 0):
			direction *= -1
		
		# Avoid edges
		if (!$RayCast2DLeft.is_colliding() and direction < 0) or (!$RayCast2DRight.is_colliding() and direction > 0):
			direction *= -1
		
		velocity.x += acceleration * delta * direction
		
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.y = 0
		if $RayCast2D.get_collider().has_method("get_linear_velocity"):
			var floor_velocity = $RayCast2D.get_collider().get_linear_velocity()
			velocity += floor_velocity * 4 * delta
		
		var collision_offset = $RayCast2D.get_collision_point() - global_position
		if collision_offset.y > feet_y - step_size: # Above surface: resnap
			global_position.y += collision_offset.y - feet_y
		else: # Below surface: climb
			velocity.x *= pow(0.4, delta)
			global_position.y -= climb_speed * delta
	else: # Far off: fall
		velocity.y += ProjectSettings.get("physics/2d/default_gravity") * delta
	
	global_position += velocity * delta
