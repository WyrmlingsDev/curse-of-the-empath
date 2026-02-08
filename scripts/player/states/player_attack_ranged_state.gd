extends PlayerState

class_name PlayerAttackRangedState

func enter(prev_state: PlayerState) -> void:
	player.animation.play("ranged")
	await player.animation.animation_finished
	player._set_state("idle")
	pass

func exit(next_state: PlayerState) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
