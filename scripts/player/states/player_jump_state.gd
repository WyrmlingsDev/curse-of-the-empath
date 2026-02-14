extends PlayerState

class_name PlayerJumpState

func enter(_prev_state: PlayerState) -> void:
	if player.jump_sound != null:
		SoundBus._queue_sound(str("player_jump_sound"), player.jump_sound, player.position)
	player.animation.play("jump")
	player.velocity.y = player.jump
	player.animation.scale.x = 1.1
	player.animation.scale.y = 1.1
	
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
