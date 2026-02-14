extends EnemyState

class_name MageAttackState

@onready var hand = preload("res://scenes/projectile/mage_projectile.tscn")

func enter(prev_state: EnemyState) -> void:
	if enemy.attack_sound != null:
			SoundBus._queue_sound(str(enemy.enemy_type + "_attack_sound"), enemy.attack_sound, enemy.position)
	
	enemy.animation.play("attack")
	enemy.velocity.x = 0
	await enemy.animation.animation_finished
	
	var new_hand = hand.instantiate()
	
	# this was written at 12 am on a school night...
	new_hand.global_position.x = enemy.global_position.x + (enemy.facing_direction.x * 200)
	new_hand.global_position.y = enemy.global_position.y - 180
	new_hand.velocity = enemy.facing_direction * 1200
	get_tree().current_scene.add_child(new_hand)
	
	# lazy timer
	enemy.animation.play("idle")
	await get_tree().create_timer(2).timeout
	enemy._set_state("idle")
