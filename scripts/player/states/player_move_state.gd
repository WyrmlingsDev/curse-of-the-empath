extends PlayerState

class_name PlayerMoveState
		
func physics_update(delta: float) -> void:
	var x = Input.get_axis("Left", "Right")
	
	if x < 0:
		player.facing_direction = Vector2.LEFT
	else:
		player.facing_direction = Vector2.RIGHT 
		
	player.velocity.x = x * player.speed
	
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		player._set_state("jump")
		return
	
	if x == 0.0:
		player._set_state("idle")
