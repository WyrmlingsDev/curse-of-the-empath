extends EnemyState

class_name SoldierAttackState

func enter(prev_state: EnemyState) -> void:
	var dir = enemy.facing_direction
	var hitbox: Area2D
	if dir == Vector2.RIGHT:
		hitbox = enemy.hitboxRight 
	else:
		hitbox = enemy.hitboxLeft
	
	if enemy.attack_sound != null:
			SoundBus._queue_sound(str(enemy.enemy_type + "_attack_sound"), enemy.attack_sound, enemy.position)
	hitbox.get_node("CollisionShape2D").disabled = false
	enemy.animation.play("attack")
	enemy.velocity.x = 0
	await enemy.animation.animation_finished
	hitbox.get_node("CollisionShape2D").disabled = true
	
	# lazy timer
	enemy.animation.play("idle")
	await get_tree().create_timer(2).timeout
	enemy._set_state("idle")

func exit(next_state: EnemyState) -> void:
	enemy.hitboxRight.get_node("CollisionShape2D").disabled = true
	enemy.hitboxLeft.get_node("CollisionShape2D").disabled = true
	enemy.attack_timer = enemy.ATTACK_DELAY
