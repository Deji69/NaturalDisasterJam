extends Node2D

var rise_speed = 0.5

func _ready():
	pass

func _process(delta):
	if ($Water.position.y > 100):
		$Water.position.y -= rise_speed
		if (rise_speed < 2):
			rise_speed += rise_speed * 0.001
