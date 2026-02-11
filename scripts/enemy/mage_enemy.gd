extends Enemy

class_name MageEnemy

@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	attack_distance = 500
	
	states = {
		"idle": preload("res://scripts/enemy/states/enemy_idle_state.gd").new(),
		"move": preload("res://scripts/enemy/states/enemy_move_state.gd").new(),
		"hurt": preload("res://scripts/enemy/states/enemy_hurt_state.gd").new(),
		"attack": preload("res://scripts/enemy/states/mage_attack_state.gd").new(),
	}
	
	for _state in states.values():
		_state.enemy = self
		add_child(_state)
	
	_set_state("idle")
	
func _physics_process(delta: float) -> void:
	if not state:
		return

	_apply_i_frames(delta)

	if not is_on_floor():
		velocity += get_gravity() * delta

	if facing_direction == Vector2.LEFT:
		animation.flip_h = false
	elif facing_direction == Vector2.RIGHT:
		animation.flip_h = true

	state.physics_update(delta)
	move_and_slide()
