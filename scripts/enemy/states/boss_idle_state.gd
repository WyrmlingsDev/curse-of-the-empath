extends EnemyState

class_name BossIdleState

func enter(prev_state: EnemyState) -> void:
	enemy.animation.play("idle")
	enemy.velocity.x = 0
	enemy.animation.position.x = -122
	enemy.animation.position.y = -311

func physics_update(delta: float) -> void:
	for source in enemy.detection.get_overlapping_bodies():
		if source.is_in_group("Player"):
			enemy.target_pos = source.global_position
			enemy._set_state("move")
			return
