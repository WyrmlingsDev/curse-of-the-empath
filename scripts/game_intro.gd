#Game will be paused in the background while intro is playing and unpaused when done
extends CanvasLayer

func _ready():
	get_tree().paused = true
	$AnimationPlayer.play("play_dialogue")
	$AnimationPlayer.animation_finished.connect(_on_finished)

func _on_finished(_anim_name):
	get_tree().paused = false
	queue_free()
