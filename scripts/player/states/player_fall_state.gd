extends PlayerState

class_name PlayerFallState

func physics_update(delta: float) -> void:
	var x = Input.get_axis("Left", "Right")
	
	player.velocity.x = x * player.speed

	if player.is_on_floor():
		if x != 0.0:
			player._set_state("move")
		else:
			player._set_state("idle")
