extends PlayerState

class_name PlayerAttackRangedState

func enter(prev_state: PlayerState) -> void:
	player.animation.scale.x = 0.3
	player.animation.scale.y = 0.3
	player.animation.play("ranged")
	await player.animation.animation_finished
	player._set_state("idle")
	pass

func physics_update(delta: float) -> void:
	pass
