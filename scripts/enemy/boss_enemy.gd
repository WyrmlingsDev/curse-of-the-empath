extends Enemy

class_name Boss

@onready var hitboxLeft: Area2D = $HitboxLeft
@onready var hitboxRight: Area2D = $HitboxRight
@onready var hitboxCenter: Area2D = $HitboxCenter

func _ready() -> void:
	attack_distance = 600
	
	states = {
		"idle": preload("res://scripts/enemy/states/boss_idle_state.gd").new(),
		"move": preload("res://scripts/enemy/states/boss_move_state.gd").new(),
		"attack": preload("res://scripts/enemy/states/soldier_attack_state.gd").new(),
		"jump": preload("res://scripts/enemy/states/jump_attack_state.gd").new()
	}
		
	for _state in states.values():
		_state.enemy = self
		add_child(_state)
	
	_set_state("idle")
	
func _physics_process(delta: float) -> void:
	if not state:
		return

	_apply_i_frames(delta)

	if facing_direction == Vector2.LEFT:
		animation.flip_h = false
	elif facing_direction == Vector2.RIGHT:
		animation.flip_h = true

	state.physics_update(delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func _check_damage_sources(_delta: Variant, hurtbox: Area2D) -> void: 
	if i_frame_timer > 0.0: 
		return 
	
	for source in hurtbox.get_overlapping_areas(): 
		if source.is_in_group(damage_source) and source.is_in_group("Player"): 
			_take_damage(source, 10.0) 
			i_frame_timer = i_frame / 1000.0
