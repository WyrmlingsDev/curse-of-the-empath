extends CharacterBody2D

class_name Enemy

@export var speed = 700.0
@export var max_health = 100.0
@export var current_health = 100.0
@export var i_frame: float = 1000.0 # in ms
@export var i_frame_timer: float = 0.0
@export var jump = -600.0
@export var attack_distance = 200
@export var target_pos: Vector2
@export var knockback_time = 0.05
@export var knockback_timer = 0.0
@export var damage_source: String = "PlayerDamageSource"

@onready var animation: AnimatedSprite2D = $Frames
@onready var detection: Area2D = $Detection
@onready var hurtbox = $Hurtbox

var state: EnemyState
var states: Dictionary[Variant, Variant] = {}
var facing_direction: Vector2 = Vector2.ZERO

var attack_timer := 0
const ATTACK_DELAY := 200.0

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
			_set_state("hurt")
			return

func _take_damage(source: Variant, amount: float) -> void:
	knockback_timer = knockback_time
	velocity.x = -facing_direction.x * 800.0
	current_health -= amount

	if current_health <= 0:
		queue_free()
