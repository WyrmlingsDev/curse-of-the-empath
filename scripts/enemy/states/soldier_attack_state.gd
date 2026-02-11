extends EnemyState

class_name SoldierAttackState

func enter(prev_state: EnemyState) -> void:
	var dir = enemy.facing_direction
	var hitbox: Area2D
	if dir == Vector2.RIGHT:
		hitbox = enemy.hitboxRight 
	else:
		hitbox = enemy.hitboxLeft
	
	hitbox.get_node("CollisionShape2D").disabled = false
	enemy.animation.play("attack")
	enemy.velocity.x = 0
	await enemy.animation.animation_finished
	hitbox.get_node("CollisionShape2D").disabled = true
	enemy._set_state("idle")
