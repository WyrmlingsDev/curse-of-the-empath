extends EnemyState

class_name JumpAttackState

var played_apex := false

func enter(prev_state: EnemyState) -> void:
	enemy.animation.position.x = 35
	enemy.animation.position.y = -142
	played_apex = false
	
	enemy.velocity.x = enemy.facing_direction.x * 300
	enemy.velocity.y = -700
	
	enemy.global_position.y -= 1
	enemy.animation.play("jump")

func physics_update(delta: float) -> void:
	if enemy.velocity.y < 0:
		enemy.animation.play("jump")
	elif enemy.velocity.y >= 0 and not played_apex:
		played_apex = true
		enemy.animation.play("apex")
	elif not enemy.is_on_floor():
		enemy.animation.play("fall")
	else:
		enemy.hitboxCenter.set_deferred("disabled", false)
		enemy.animation.play("land")
		enemy.velocity.x = 0
		enemy.animation.position.x = -39
		enemy.animation.position.y = -31
		await enemy.animation.animation_finished
		enemy.hitboxCenter.set_deferred("disabled", true)
		enemy._set_state("idle")
