#Attach to boss to play ending scene on death
extends CharacterBody2D

@export var boss_death_scene: PackedScene

var health = 100

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	if not SceneManager.ending_seen:
		SceneManager.ending_seen = true
		if boss_death_scene:
			var dialogue = boss_death_scene.instantiate()
			get_tree().root.add_child(dialogue)
			queue_free()
