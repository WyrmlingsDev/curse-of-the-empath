extends EnemyState

class_name BossAttackState

func enter(prev_state: EnemyState) -> void:
	var dir = enemy.facing_direction
	var hitbox: Area2D
	if dir == Vector2.RIGHT:
		hitbox = enemy.hitboxRight 
	else:
		hitbox = enemy.hitboxLeft
	
	var sounds: Array[AudioStreamMP3] = enemy.attack_sounds
	
	if not sounds.is_empty():
		var random = randi_range(0, sounds.size() - 1)
		SoundBus._queue_sound_volume("boss_attack_sound", sounds[random], enemy.position, -10.0)
		
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
