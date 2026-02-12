extends Enemy

class_name Boss

@onready var hitboxLeft: Area2D = $HitboxLeft
@onready var hitboxRight: Area2D = $HitboxRight
@onready var hitboxCenter: Area2D = $HitboxCenter
@export var attack_sounds: Array[AudioStreamMP3]
@export var damage_sounds: Array[AudioStreamMP3]
@export var jump_attack_sound: AudioStreamMP3

func _ready() -> void:	
	states = {
		"idle": preload("res://scripts/enemy/states/boss_idle_state.gd").new(),
		"move": preload("res://scripts/enemy/states/boss_move_state.gd").new(),
		"attack": preload("res://scripts/enemy/states/boss_attack_state.gd").new(),
		"jump": preload("res://scripts/enemy/states/jump_attack_state.gd").new()
	}
		
	for _state in states.values():
		_state.enemy = self
		add_child(_state)
	
	_set_state("idle")
	
func _physics_process(delta: float) -> void:
	if not state:
		return

	if facing_direction == Vector2.LEFT:
		animation.flip_h = false
	elif facing_direction == Vector2.RIGHT:
		animation.flip_h = true
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_apply_i_frames(delta)
	state.physics_update(delta)
	_check_damage_sources(delta)
	move_and_slide()

func _check_damage_sources(_delta: Variant) -> void: 
	if i_frame_timer > 0.0: 
		return 
	
	for source in hurtbox.get_overlapping_areas(): 
		if source.is_in_group(damage_source) and source.is_in_group("Player"): 
			EventBus.emit_signal("on_enemy_damage", self, source)
			_take_damage(source, 10.0) 
			i_frame_timer = i_frame / 1000.0
