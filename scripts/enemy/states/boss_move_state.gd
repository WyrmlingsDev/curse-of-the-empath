extends EnemyState

class_name BossWalkState

func enter(prev_state: EnemyState) -> void:
	enemy.animation.play("walk")
	enemy.animation.position.x = -122
	enemy.animation.position.y = -311
	
func exit(next_state: EnemyState) -> void:
	enemy.target_pos = Vector2.ZERO
	
func physics_update(delta: float) -> void:
	for source in enemy.detection.get_overlapping_bodies():
		if source.is_in_group("Player"):
			enemy.target_pos = source.global_position
			break
				
	var dist: float = enemy.global_position.distance_to(enemy.target_pos)
	if dist <= 600:
		enemy.velocity = Vector2.ZERO
		enemy._set_state("attack")
		return
	if dist <= 1000:
		enemy._set_state("jump")
		return
	
	var dir := (enemy.target_pos - enemy.global_position).normalized()
	enemy.velocity = dir * enemy.speed
	enemy.velocity.y = 0
	
	if enemy.velocity.x < 0:
		enemy.facing_direction = Vector2.LEFT
	elif enemy.velocity.x > 0:
		enemy.facing_direction = Vector2.RIGHT 
