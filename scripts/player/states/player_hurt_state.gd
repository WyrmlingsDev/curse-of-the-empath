extends PlayerState

class_name PlayerHurtState

@export var knockback_speed: float = 1200.0
@export var knockback_time: float = 0.30
@export var damage_amount: float = 10.0

var knockback_timer: float = 0.0

func enter(prev_state: PlayerState) -> void:
	if not player.damage_sounds.is_empty():
		var random = randi_range(0, player.damage_sounds.size() - 1)
		SoundBus._queue_sound(str("player_damage_sound"), player.damage_sounds[random], player.position)
	player.animation.scale.x = 1.2
	player.animation.scale.y = 1.2
	player.animation.play("hurt")
	
	knockback_timer = knockback_time
	player.velocity.x = -player.facing_direction.x * knockback_speed
	
	player.current_health -= damage_amount
	player.health_bar.value = player.current_health
	
	player.i_frame_timer = player.i_frame / 1000.0
	

func physics_update(delta: float) -> void:
	if knockback_timer > 0.0:
		knockback_timer -= delta
	else:
		player._set_state("idle")
