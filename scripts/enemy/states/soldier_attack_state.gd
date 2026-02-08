extends EnemyState

class_name SoldierAttackState

func enter(prev_state: EnemyState) -> void:
	enemy.animation.play("attack")
	enemy.velocity.x = 0
	await enemy.animation.animation_finished
	enemy._set_state("idle")
