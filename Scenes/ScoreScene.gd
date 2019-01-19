extends Control

signal back()

func display_score(score):
	$Panel/Label.text = "Your score: "+str(score["Score"])


func _on_Button_pressed():
	emit_signal("back")
