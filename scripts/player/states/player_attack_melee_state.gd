extends PlayerState

class_name PlayerAttackMeleeState

var combo_step := 1
var input_buffered := false
var timeout_timer := 0.0

func enter(prev_state: PlayerState) -> void:	
	if not player.damage_sounds.is_empty():
		var random = randi_range(0, player.attack_sounds.size() - 1)
		SoundBus._queue_sound(str("player_attack_sound"), player.attack_sounds[random], player.position)
	combo_step = 1
	input_buffered = false
	timeout_timer = 0.0

	player.animation.scale.x = 1.3
	player.animation.scale.y = 1.3
	_play_combo()
	
func exit(next_state: PlayerState) -> void:
	player.hitboxRight.get_node("CollisionShape2D").disabled = true
	player.hitboxLeft.get_node("CollisionShape2D").disabled = true

func physics_update(delta: float) -> void:
	timeout_timer += delta

	if Input.is_action_just_pressed("Melee"):
		input_buffered = true
		timeout_timer = 0.0

	if timeout_timer >= 0.5:
		player._set_state("idle")

func _play_combo() -> void:
	if not player.attack_sounds.is_empty():
		var random = randi_range(0, player.attack_sounds.size() - 1)
		SoundBus._queue_sound(str("player_attack_sound"), player.attack_sounds[random], player.position)
	var dir = player.facing_direction
	var hitbox: Area2D
	if dir == Vector2.RIGHT:
		hitbox = player.hitboxRight 
	else:
		hitbox = player.hitboxLeft
	
	hitbox.get_node("CollisionShape2D").disabled = false
	match combo_step:
		1: player.animation.play("melee_1")
		2: player.animation.play("melee_2")
		3: player.animation.play("melee_3")
		_: player.animation.play("melee_2")

	await player.animation.animation_finished
	hitbox.get_node("CollisionShape2D").disabled = true

	if input_buffered:
		input_buffered = false
		combo_step += 1
		_play_combo()
	else:
		player._set_state("idle")
