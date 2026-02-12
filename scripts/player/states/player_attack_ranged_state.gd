extends PlayerState

class_name PlayerAttackRangedState

@onready var arrow = preload("res://scenes/projectile/arrow.tscn")

func enter(prev_state: PlayerState) -> void:
	if player.ranged_sound != null:
		SoundBus._queue_sound(str("player_ranged_sound"), player.ranged_sound, player.position)
	player.animation.scale.x = 0.3
	player.animation.scale.y = 0.3
	player.animation.play("ranged")
	await player.animation.animation_finished
	
	var new_arrow = arrow.instantiate();
	
	# this was written at 12 am on a school night...
	new_arrow.global_position.x = player.global_position.x + (player.facing_direction.x * 200)
	new_arrow.global_position.y = player.global_position.y - 180
	new_arrow.velocity = player.facing_direction * 1200
	get_tree().current_scene.add_child(new_arrow)
	
	player._set_state("idle")
