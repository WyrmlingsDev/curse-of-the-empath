#Will play boss intro when connected to an area2d node with collision

extends Area2D
#Export Variables

@export var boss_dialogue_scene: PackedScene

#Initializes function in current Node
func _ready():
	self.body_entered.connect(_on_body_entered)

#Triggers event when player enters
func _on_body_entered(_body: CharacterBody2D):
	if "Player" in Player and not SceneManager.boss_intro_seen:
		SceneManager.boss_intro_seen = true
		spawn_dialogue(boss_dialogue_scene)

func spawn_dialogue(scene):
	var instance = scene.instantiate()
	get_tree().root.add_child.call_deferred(instance)
