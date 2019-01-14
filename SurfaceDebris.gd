# Spawn in debris items and have them float around
# Heavier debris should sink to the bottom
extends Node

const max_debris_items = 4
var debris_scenes = [
	preload("res://DebrisItemScenes/TestDebrisItem.tscn"),
	preload("res://DebrisItemScenes/TestDebrisItem2.tscn"),
	preload("res://DebrisItemScenes/TestDebrisItem3.tscn"),
]
var debris_items = []
var direction = 0		# 0 left, 1 right

class DebrisItem:
	var inst
	var dir
	var bob_dir = 0
	var bob_fac = 0
	var speed = rand_range(1, 2)

func _ready():
	$SpawnTimer.wait_time = 4
	$SpawnTimer.stop()   # temporarily disabled

func _physics_process(delta):
	for item in debris_items:
		item.inst.position.y = get_parent().position.y - 270 + (item.bob_fac * 8)
		if item.bob_fac >= 1:
			item.bob_dir = 1
		else:
			if item.bob_fac <= 0:
				item.bob_dir = 0
		if item.bob_dir == 1:
			item.bob_fac += 0.1 * (delta / 100)
		else:
			item.bob_fac -= 0.1 * (delta / 100)
		var block = item.inst.get_node("DraggableBlock");
		if item.dir == 0:
			block.set_axis_velocity(Vector2(-10.5 * item.speed, 0))
		else:
			block.set_axis_velocity(Vector2(10.5 * item.speed, 0))
		if item.inst.position.x < -40:
			item.inst.queue_free()
			debris_items.erase(item)
		else: if item.inst.position.x > 1060:
			item.inst.queue_free()
			debris_items.erase(item)

func _on_SpawnTimer_timeout():
	if debris_items.size() < max_debris_items:
		_spawn_debris_item()
	
func _spawn_debris_item():
	var item = DebrisItem.new()
	item.inst = debris_scenes[randi() % debris_scenes.size()].instance()
	item.dir = randi() % 2
	
	debris_items.push_back(item)
	add_child(item.inst)
	
	#item.inst.get_node("DraggableBlock").set_mode(RigidBody2D.MODE_KINEMATIC)
	
	item.inst.position = get_parent().position
	item.inst.position.y -= 270
	
	if item.dir == 0:
		item.inst.position.x = 1054
	else:
		item.inst.position.x = -32
