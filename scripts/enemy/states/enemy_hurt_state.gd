extends EnemyState

class_name EnemyHurtState

@export var knockback_speed: float = 800.0
@export var knockback_time: float = 0.30
@export var damage_amount: float = 10.0

var knockback_timer: float = 0.0

func enter(prev_state: EnemyState) -> void:
	enemy.animation.play("hurt")
	
	knockback_timer = knockback_time
	enemy.velocity.x = -enemy.facing_direction.x * knockback_speed
	
	enemy.current_health -= damage_amount
	if enemy.current_health <= 0:
		enemy.queue_free()
		return
	
	enemy.i_frame_timer = enemy.i_frame / 1000.0

func physics_update(delta: float) -> void:
	if knockback_timer > 0.0:
		knockback_timer -= delta
		enemy.move_and_slide()
	else:
		enemy._set_state("idle")
