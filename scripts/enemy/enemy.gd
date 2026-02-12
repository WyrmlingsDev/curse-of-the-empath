extends CharacterBody2D

class_name Enemy

const ATTACK_DELAY := 5.0

@export var enemy_type: String = "Enemy"
@export var speed: float = 700.0
@export var max_health: float = 100.0
@export var current_health: float = 100.0
@export var i_frame: float = 800.0 # in ms
@export var i_frame_timer: float = 0.0
@export var jump: float = -600.0
@export var attack_distance: float = 200
@export var target_pos: Vector2
@export var knockback_time: float = 0.05
@export var knockback_timer: float = 0.0
@export var damage_source: String = "PlayerDamageSource"

@export var attack_sound: AudioStreamMP3
@export var damage_sound: AudioStreamMP3
@export var death_sound: AudioStreamMP3

@onready var animation: AnimatedSprite2D = $Frames
@onready var detection: Area2D = $Detection
@onready var hurtbox = $Hurtbox

var state: EnemyState
var states: Dictionary[Variant, Variant] = {}
var facing_direction: Vector2 = Vector2.ZERO
var attack_timer = 0

func _set_state(state_name) -> void:
	if not states.has(state_name):
		push_warning("State '%s' not found" % state_name)
		return

	if state == states[state_name]:
		return

	if state:
		state.exit(states[state_name])

	var prev: EnemyState = state
	state = states[state_name]
	state.enter(prev)

func _apply_i_frames(delta):
	if i_frame_timer > 0.0:
		i_frame_timer -= delta
		i_frame_timer = max(i_frame_timer, 0.0)

func _check_damage_sources(_delta: Variant) -> void:
	if i_frame_timer > 0.0:
		return
	
	for source in hurtbox.get_overlapping_areas():
		if source.is_in_group(damage_source) and source.is_in_group("Player"):
			EventBus.emit_signal("on_enemy_damage", self, source)
			_set_state("hurt")
			return

func _take_damage(source: Variant, amount: float) -> void:
	current_health -= amount

	if current_health <= 0:
		queue_free()
