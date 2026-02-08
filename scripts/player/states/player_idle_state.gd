extends PlayerState

class_name PlayerIdleState

func enter(prev_state: PlayerState) -> void:
	player.animation.play("idle")
	player.velocity.x = 0

func physics_update(delta: float) -> void:
	var x = Input.get_axis("Left", "Right")
	
	if Input.is_action_just_pressed("Ranged"):
		player._set_state("ranged")
		return
	
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		player._set_state("jump")
		return
	
	if x != 0:
		player._set_state("move")
		return
