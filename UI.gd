extends CanvasLayer

# Declare member variables here. Examples:
export var score_string = "Score: %s"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var score = get_parent().get_node("Flooding").total_level
	score /= 100
	$Score.text = score_string % score
	pass
