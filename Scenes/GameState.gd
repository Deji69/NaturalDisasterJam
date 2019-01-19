extends Node

export(Array, PackedScene) var levels
export(PackedScene) var main_menu
export(PackedScene) var credits
export(PackedScene) var score_scene


enum State{
	MAIN,
	CREDITS,
	GAME,
	SCORE
}

var current_scene = null

# We assume we are in the game state if we are not set to anything
# Most likely use case when testing the game, just launching the game scene
var current_state = State.MAIN


func _ready():
	on_back()


func play(level_index):
	assert level_index >= 0 and level_index < levels.size()
	current_state = State.GAME
	remove_child(current_scene)
	current_scene.queue_free()
	current_scene = levels[level_index].instance()
	add_child(current_scene)
	current_scene.connect(
		"game_end",
		self,
		"_on_game_end"
		)


func _on_game_end(score: Dictionary):
	remove_child(current_scene)
	current_scene.queue_free()
	current_scene = score_scene.instance()
	add_child(current_scene)
	current_scene.display_score(score)
	current_scene.connect("back", self, "on_back")
	current_state = State.SCORE


func on_back():
	if current_scene != null:
		current_scene.queue_free()
	current_scene = main_menu.instance()
	add_child(current_scene)
	current_scene.connect(
		"play_level",
		self,
		"play"
		)
