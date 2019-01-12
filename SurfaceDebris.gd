# Spawn in debris items and have them float around
# Heavier debris should sink to the bottom
extends Node2D

var debris_items = [
	preload("res://DebrisItemScenes/TestDebrisItem.tscn")
]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if (delta > 2000):
		
	pass
