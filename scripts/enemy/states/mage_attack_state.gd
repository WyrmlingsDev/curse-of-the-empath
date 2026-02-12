extends EnemyState

class_name MageAttackState

func enter(prev_state: EnemyState) -> void:
	if enemy.attack_sound != null:
			SoundBus._queue_sound(str(enemy.enemy_type + "_attack_sound"), enemy.attack_sound, enemy.position)
	
	enemy.animation.play("attack")
	enemy.velocity.x = 0
	await enemy.animation.animation_finished
	
	# lazy timer
	enemy.animation.play("idle")
	await get_tree().create_timer(2).timeout
	enemy._set_state("idle")
