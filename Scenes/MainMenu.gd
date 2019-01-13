extends CanvasLayer

signal play_level(level_idx)


func _on_Quit_pressed():
	get_tree().quit()


func _on_Play_pressed():
	emit_signal("play_level", 0)
