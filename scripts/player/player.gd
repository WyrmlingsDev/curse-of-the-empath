extends CharacterBody2D

class_name Player

@export var speed = 300.0
@export var max_health = 100.0
@export var current_health = 100.0
@export var i_frame = 800.0
@export var i_frame_timer = 0.0
@export var jump = -300.0

var state: PlayerState
var states: Dictionary[Variant, Variant] = {}
var facing_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	states = {
		"idle": preload("res://scripts/player/states/player_idle_state.gd").new(),
		"move": preload("res://scripts/player/states/player_move_state.gd").new(),
		"jump": preload("res://scripts/player/states/player_jump_state.gd").new(),
		"fall": preload("res://scripts/player/states/player_fall_state.gd").new(),
		"melee": preload("res://scripts/player/states/player_attack_melee_state.gd").new(),
		"ranged": preload("res://scripts/player/states/player_attack_ranged_state.gd").new(),
	}
	
	for _state in states.values():
		_state.player = self
		add_child(_state)
	
	_set_state("idle")
	
func _physics_process(delta: float) -> void:
	if not state:
		return

	_apply_i_frames(delta)

	if not is_on_floor():
		velocity += get_gravity() * delta

	state.physics_update(delta)
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
