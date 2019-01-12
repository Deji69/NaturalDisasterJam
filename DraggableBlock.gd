extends RigidBody2D

export var interactable = true
export var dragging_linear_damp = -1.0
export var dragging_angular_damp = -1.0
export var dragging_acceleration = 20
export var dragging_time = 0.1
export var dragging_mass = 0.1

var dragging = false
var drag_point = Vector2()
onready var original_linear_damp = linear_damp
onready var original_angular_damp = angular_damp
onready var original_mass = mass

func _ready():
	set_physics_process(false)

# Handle mouse clicks
func _input_event(viewport, event, shape_idx):
	if interactable:
		event = make_input_local(event)
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.is_pressed():
				set_dragging(true)
				drag_point = get_local_mouse_position()

func _input(event):
	if event is InputEventMouseButton and dragging:
		if event.button_index == BUTTON_LEFT and !event.is_pressed():
			set_dragging(false)

func set_dragging(state):
	dragging = state
	if dragging:
		linear_damp = dragging_linear_damp
		angular_damp = dragging_angular_damp
		mass = dragging_mass
	else:
		linear_damp = original_linear_damp
		angular_damp = original_linear_damp
		mass = original_mass
		for body in get_colliding_bodies():
			if body.get("interactable") == false:
				interactable = false
				input_pickable = false
	set_physics_process(dragging)

# Drag
func _physics_process(delta):
	if dragging:
		var from_point = to_global(drag_point)
		var to_point = get_global_mouse_position()
		
		var target_velocity = (to_point - from_point) / dragging_time
		apply_impulse(from_point - global_position, (target_velocity - linear_velocity).clamped(delta * dragging_acceleration) * mass)
