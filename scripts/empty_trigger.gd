extends Area2D

class_name GameTrigger

#Export Variables
@export_group("Trigger Settings")
@export var trigger_name: String = "DefaultTrigger"
@export var logic_script: GDScript

#Initializes function in current Node
func _ready():
	self.body_entered.connect(_on_body_entered)

#Triggers event when player enters
func _on_body_entered(_body: CharacterBody2D):
	print("Player Detected")
	#Loads script from side panel
	if logic_script:
		var script_instance = logic_script.new()
		#Checks for run method in loaded script
		if script_instance.has_method("run"):
			script_instance.run()

	#Self deletes trigger
	queue_free()
