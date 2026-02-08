extends EnemyState

class_name EnemyIdleState

func enter(prev_state: EnemyState) -> void:
	enemy.animation.play("idle")
	enemy.velocity.x = 0

func physics_update(delta: float) -> void:
	for source in enemy.detection.get_overlapping_bodies():
		if source.is_in_group("Player"):
			print("Player detected")
			enemy.target_pos = source.global_position
			enemy._set_state("move")
			return
