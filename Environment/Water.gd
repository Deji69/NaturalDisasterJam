extends Area2D

var objs_in_kin_area = []

var dirty_objs = []


func _on_KinematicArea_body_entered(body):
	if not body is RigidBody2D:
		return 
	objs_in_kin_area.append(body)
	dirty_objs.append(body)


func _on_KinematicArea_body_exited(body):
	if $KillArea.get_overlapping_bodies().has(body):
		body.queue_free()
	objs_in_kin_area.erase(body)


func _physics_process(delta):
	for body in dirty_objs:
		body.mode = RigidBody2D.MODE_STATIC
	dirty_objs = []


func _on_InstakillArea_body_entered(body):
	body.queue_free()
	pass # Replace with function body.
