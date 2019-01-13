extends Node2D

# the on-screen water height
export var screen_level = 0.0
# the water height for calculating the score
export var total_level = 0.0
var rise_speed = 2.5

func _ready():
	$Water.connect('body_entered', self, '_on_water_entered') 
	$Water.connect('body_exited', self, '_on_water_exited') 

func _process(delta):
	if $Water.position.y > 500:
		$Water.move_local_y(-rise_speed)
		total_level += rise_speed
		screen_level += rise_speed
		if (rise_speed < 2):
			rise_speed += rise_speed * 0.001
	for obj in objects:
		if obj is RigidBody2D:
			obj.apply_impulse(Vector2(0, 0), Vector2(0, -20) * delta)

var objects = []

func _on_water_entered(body):
	objects.append(body)
	if body.is_class("DebrisItem"):
		body.enter_water()

func _on_water_exited(body):
	var idx = objects.find(body)
	if idx != -1:
		objects.remove(idx)