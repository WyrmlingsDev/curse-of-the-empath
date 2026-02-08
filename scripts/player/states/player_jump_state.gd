extends PlayerState

class_name PlayerJumpState

func enter(_prev_state: PlayerState) -> void:
	player.velocity.y = player.jump
	
func physics_update(delta: float) -> void:
	var x = Input.get_axis("Left", "Right")
	
	if x < 0:
		player.facing_direction = Vector2.LEFT
	elif x > 0:
		player.facing_direction = Vector2.RIGHT 
		
	player.velocity.x = x * player.speed

	if player.is_on_floor():
		player._set_state("idle")
		return

	if player.velocity.y > 0:
		player._set_state("fall")
