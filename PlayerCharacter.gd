extends KinematicBody2D

var motion = Vector2()
var motionx = 0
var motiony = 0

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		motion.x = 100
	if Input.is_action_pressed("ui_left"):
		motion.x = -100
	move_and_slide(motion)
	motion = Vector2()
	pass