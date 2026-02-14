extends Area2D

@onready var loc = preload("res://scenes/stages/cathedral.tscn")

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		loc.instantiate()
		get_tree().call_deferred("change_scene_to_packed", loc)
