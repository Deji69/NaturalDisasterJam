extends Node2D

func _ready():
	$Water.scale.y = 0

func _process(delta):
	$Water.scale.y += 0.01
	$Rain.Extent.y -= 0.01
