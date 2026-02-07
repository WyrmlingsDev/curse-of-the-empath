extends Area2D

class_name GameTrigger

#Initializes function in current Node
func _ready():
	self.body_entered.connect(_on_body_entered)

#Triggers event when player enters
func _on_body_entered(body: CharacterBody2D):
	print("Player Detected")
	#Space for triggered event
	
	#Trigger self delete
	queue_free()
