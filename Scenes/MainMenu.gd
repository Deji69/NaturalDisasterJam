extends CanvasLayer

signal play_level(level_idx)

export(Resource) var focus_audio
export(Resource) var pressed_audio

func _ready():
	for b in $Control/VBoxContainer.get_children():
		b.connect("focus_entered", $Focus, "play")
		b.connect("button_down",$Click, "play")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Play_pressed():
       emit_signal("play_level", 0)


func _on_Credits_pressed():
	$Control/AcceptDialog.popup()
