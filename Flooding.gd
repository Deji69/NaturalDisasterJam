extends Node2D

var riseSpeed = 0.5

func _ready():
	pass

func _process(delta):
	$Water.position.y -= riseSpeed
	if (riseSpeed < 2):
		riseSpeed += riseSpeed * 0.001
