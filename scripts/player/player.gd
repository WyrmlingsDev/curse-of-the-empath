extends CharacterBody2D

class_name Player

@export var speed = 800.0
@export var max_health = 100.0
@export var current_health = 100.0
@export var i_frame = 1200.0
@export var i_frame_timer = 0.0
@export var jump = -600.0
@export var damage_source: String = "EnemyDamageSource"
@export var lifesteal_timer = 0
@export var lifesteal_progress = 0
@export var is_lifestealing = false
@export var jump_sound: AudioStreamMP3
@export var attack_sounds: Array[AudioStreamMP3]
@export var damage_sounds: Array[AudioStreamMP3]
@export var ranged_sound: AudioStreamMP3
@export var normal_slash: AudioStreamMP3
@export var boss_slash: AudioStreamMP3

@onready var animation := $Frames
@onready var hurtbox := $Hurtbox
@onready var hitboxLeft := $HitboxLeft
@onready var hitboxRight := $HitboxRight
@onready var health_bar := $UI/TextureProgressBar
@onready var lifesteal_bar := $UI/ProgressBar
@onready var lifesteal_noise := $Lifesteal

var state: PlayerState
var states: Dictionary[Variant, Variant] = {}
var facing_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	states = {
		"idle": preload("res://scripts/player/states/player_idle_state.gd").new(),
		"move": preload("res://scripts/player/states/player_move_state.gd").new(),
		"jump": preload("res://scripts/player/states/player_jump_state.gd").new(),
		"hurt": preload("res://scripts/player/states/player_hurt_state.gd").new(),
		"fall": preload("res://scripts/player/states/player_fall_state.gd").new(),
		"melee": preload("res://scripts/player/states/player_attack_melee_state.gd").new(),
		"ranged": preload("res://scripts/player/states/player_attack_ranged_state.gd").new(),
	}
	
	for _state in states.values():
		_state.player = self
		add_child(_state)
	
	_set_state("idle")
	
	EventBus.connect("on_enemy_damage", _on_enemy_damage)
	
func _physics_process(delta: float) -> void:
	if not state:
		return
		
	if is_lifestealing:
		lifesteal_timer += delta
		
	if is_lifestealing and lifesteal_timer >= 10:
		is_lifestealing = false
		lifesteal_timer = 0.0
		lifesteal_noise.stop()
		
	if lifesteal_progress >= 100 and Input.is_action_just_pressed("Lifesteal"):
		lifesteal_progress = 0
		lifesteal_bar.value = lifesteal_progress
		lifesteal_timer = 0.0 
		is_lifestealing = true
		lifesteal_noise.play()

	if not is_on_floor():
		velocity += get_gravity() * delta

	if facing_direction == Vector2.LEFT:
		animation.flip_h = true
	elif facing_direction == Vector2.RIGHT:
		animation.flip_h = false

	_apply_i_frames(delta)
	state.physics_update(delta)
	_check_damage_sources(delta)
	move_and_slide()

func _set_state(state_name) -> void:
	if not states.has(state_name):
		push_warning("State '%s' not found" % state_name)
		return

	if state == states[state_name]:
		return

	if state:
		state.exit(states[state_name])

	var prev: PlayerState = state
	state = states[state_name]
	state.enter(prev)

func _apply_i_frames(delta):
	if i_frame_timer > 0.0:
		i_frame_timer -= delta
		i_frame_timer = max(i_frame_timer, 0.0)

func _on_enemy_damage(entity: Enemy, source: Node2D):
	if not source.is_in_group("Projectile"):
		if entity.enemy_type == "Boss":
			SoundBus._queue_sound_volume("enemy_hit", boss_slash, position, -5.0)
		else:
			SoundBus._queue_sound_volume("enemy_hit", normal_slash, position, -5.0)
			
	if is_lifestealing:
		current_health += 10
		health_bar.value = current_health
		return
	
	lifesteal_progress += 10
	lifesteal_bar.value = lifesteal_progress

func _check_damage_sources(_delta: Variant) -> void:
	if i_frame_timer > 0.0:
		return
	
	for source in hurtbox.get_overlapping_areas():
		if source.is_in_group(damage_source) and source.is_in_group("Enemy"):
			_set_state("hurt")
			return
