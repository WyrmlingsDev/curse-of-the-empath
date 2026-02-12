#Will play intro scene when game is loaded
#Add to stage root node when ready

extends Node

@export var game_intro: PackedScene

func _ready():
	if not SceneManager.intro_seen:
		SceneManager.intro_seen = true
		spawn_dialogue(game_intro)

func spawn_dialogue(scene):
	var instance = scene.instantiate()
	get_tree().root.add_child.call_deferred(instance)
