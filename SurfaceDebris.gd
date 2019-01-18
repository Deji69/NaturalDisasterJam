# Spawn in debris items and have them float around
# Heavier debris should sink to the bottom
extends Node

export var max_debris_items = 4
export(Array, NodePath) var spawn_positions_paths
var spawn_positions = []
# Object under which the debris will be spawned
# They can't be children of the water otherwise they will move upwards
# with the water when they are set as kinematic
export(NodePath) var spawn_parent_path
onready var spawn_parent = get_node(spawn_parent_path)
var _current_debris_number = 0

var debris_scenes = [
	preload("res://DebrisItemScenes/Dome.tscn"),
	preload("res://DebrisItemScenes/RoofTri.tscn"),
	preload("res://DebrisItemScenes/Table.tscn"),
	preload("res://DebrisItemScenes/Shield.tscn"),
	preload("res://DebrisItemScenes/Roof.tscn"),
	preload("res://DebrisItemScenes/Door.tscn"),
	preload("res://DebrisItemScenes/Cart.tscn")
]

func _ready():
	$SpawnTimer.wait_time = 4
	$SpawnTimer.start()
	for p in spawn_positions_paths:
		spawn_positions.append(get_node(p))


func _on_SpawnTimer_timeout():
	if _current_debris_number < max_debris_items:
		_spawn_debris_item()
	
func _spawn_debris_item():
	var item = debris_scenes[randi() % debris_scenes.size()].instance()
	var spawn_position = spawn_positions[randi() % spawn_positions.size()]
	var float_direction = spawn_position.direction
	item.horizontal_movement = Vector2(float_direction.x, item.horizontal_movement.y)
	_current_debris_number += 1
	spawn_parent.add_child(item)
	item.global_position = spawn_position.global_position
	#Binding in also who is being destroyed cuz why not
	item.connect("tree_exiting", self, "_on_debris_destroyed", [item])


func _on_debris_destroyed(_who):
	_current_debris_number -= 1
