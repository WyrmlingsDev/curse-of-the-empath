extends CharacterBody2D

class_name Enemy

@export var speed = 700.0
@export var max_health = 100.0
@export var current_health = 100.0
@export var i_frame = 800.0
@export var i_frame_timer = 0.0
@export var jump = -600.0
@export var attack_distance = 200
@export var target_pos: Vector2

@onready var animation: AnimatedSprite2D = $Frames
@onready var detection: Area2D = $Detection

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
