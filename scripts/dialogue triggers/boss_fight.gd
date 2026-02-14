#This will pause the game when the dialogue for the boss fight is playing

extends CanvasLayer

func _ready():
	get_tree().paused = true
	$AnimationPlayer.play("play_dialogue")
	$AnimationPlayer.animation_finished.connect(_on_finished)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Skip"):
		_on_finished(self)

func _on_finished(_anim_name):
	get_tree().paused = false
	queue_free()
