extends Position2D

export var ndrops = 700
export (Vector2) var Extent = Vector2(1024, 600)

class RainDrop:
	var pos = Vector2()
	var vel = 1
	var color = Color(1, 1, 1, 1)
	var frame = 0
	var state = 0
	var timer = 0.1

var collision_mask = 2147483647  #0+1+2+4+8+16+32
var extents = null
var drops = []
var rain_dir = Vector2(0, 2).normalized() * 150
var raintex = preload("res://rain_1.png")
var frames_h = 1
var frames_v = 5
var frames = [[], [0], [1, 2, 3, 4]]
var frame_rects = []
var frame_size = Vector2()
var frame_offset = Vector2(3, 7)

func _ready():
	extents = Rect2(global_position, Extent)
	
	# prepare texture
	frame_size = Vector2(raintex.get_size().x / frames_h, raintex.get_size().y / frames_v)
	for y in range(frames_v):
		for x in range(frames_h):
			frame_rects.append(Rect2(Vector2(x * frame_size.x, y * frame_size.y), frame_size))
	
	# prepare rain drops
	var space_state = get_world_2d().direct_space_state
	for n in range(ndrops):
		var d = RainDrop.new()
		_reset_drop(d, space_state, true)
		drops.append(d)

func _physics_process(delta):
	# update drop positions
	var space_state = get_world_2d().direct_space_state
	for d in drops:
		_drop_fsm(d, delta, space_state)
	update()

func _drop_fsm(d, delta, space_state):
	if d.state == 1:
		# dropping state
		# update position
		d.pos.position += d.vel * rain_dir * delta
		# check collisions
		var results = space_state.intersect_point(d.pos.position, 32, [], self.collision_mask)
		if not results.empty():
			#if results[0].collider.get_class() != "Area2D":
			d.timer = 0.1
			d.state = 2
			d.frame = 0
		# check end of extents
		if not extents.has_point(d.pos.position):
			# reset drop
			_reset_drop(d, space_state)
	elif d.state == 2:
		# splash state
		# update frame
		d.timer -= delta
		if d.timer <= 0:
			d.timer = 0.05
			if (d.frame + 1) >= frames[2].size():
				# reset drop
				_reset_drop(d, space_state)
				return
			d.frame += 1

func _reset_drop(d, space_state, initial = false):
	var pos = Vector2()
	if (initial):
		pos = _get_random_initial_position(space_state)
	else:
		pos = _get_random_reset_position(space_state)
	if pos:
		d.pos = Rect2(pos, frame_size)
		d.vel = rand_range(0.8, 1.0)
		d.state = 1
		d.frame = 0
		d.color = Color(1, 1, 1, rand_range(0.1, 0.4))
	else:
		d.state = -1
		d.color = Color(1, 1, 1, 0)

func _get_random_initial_position(space_state = null):
	if space_state == null:
		space_state = get_world_2d().direct_space_state
		
	#extents
	for try in range(1000):
		# generate candidate position
		var candidate_pos = extents.position + Vector2(
			rand_range(0, extents.size.x),
			rand_range(0, extents.size.y)
		)
		# check collisions
		var results = space_state.intersect_point(candidate_pos, 32, [], self.collision_mask)
		if results.empty():
			return candidate_pos
	
	print("ERROR: Could not find a random position")
	return Vector2(0, 0)

func _get_random_reset_position(space_state):
	for try in range(1000):
		var candidate_pos = extents.position + Vector2(
			rand_range(0, extents.size.x),
			0
		)
		# check collisions
		var results = space_state.intersect_point(candidate_pos, 32, [], self.collision_mask)
		if results.empty():
			return candidate_pos + extents.position


func _draw():
	for d in drops:
		if d.state != -1:
			var texpos = d.pos
			texpos.position -= frame_offset + global_position
			draw_texture_rect_region(raintex, texpos, frame_rects[frames[d.state][d.frame]], d.color)
