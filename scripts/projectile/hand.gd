extends CharacterBody2D

class_name Hand

var speed: float = 400.0
var life_timer: float = 0.0

@onready var area = $Hitbox
	
func _physics_process(delta: float) -> void:
	life_timer += delta
	
	if life_timer > 1.0:
		queue_free()
		return
	
	for source in area.get_overlapping_bodies():
		if source.is_in_group("Player"):
			queue_free()
			return
			
	move_and_slide()
