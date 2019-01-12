# Spawn in debris items and have them float around
# Heavier debris should sink to the bottom
extends Node2D

var debris_scenes = [
	preload("res://DebrisItemScenes/TestDebrisItem.tscn"),
	preload("res://DebrisItemScenes/TestDebrisItem2.tscn"),
]
var debris_items = []
var direction = 0		# 0 left, 1 right

func _ready():
	$SpawnTimer.start()

func _process(delta):
	for item in debris_items:
		#item.position.y = 0
		#if direction == 0:
		#	item.position.x -= 0.1
		#else:
		#	item.position.x += 0.1
		pass


func _on_SpawnTimer_timeout():
	var scn = debris_scenes[randi() % debris_scenes.size()]
	var item = scn.instance()
	item.position = position
	direction = randi() % 2
	# spawn origin opposite from direction
	#item.position = self.position
	debris_items.push_back(item)
	add_child(item)
	$SpawnTimer.wait_time = 0.5
	$SpawnTimer.start()
