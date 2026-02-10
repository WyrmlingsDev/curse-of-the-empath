#This is not finished

extends Area2D

class_name DialogueTrigger

#Export Variables to load dialogue and sprites
@export var dialogue_scene: PackedScene
@export_multiline var dialogue_text: String = ""
@export var character_portrait: CompressedTexture2D

#Initializes function in current Node
func _ready():
	self.body_entered.connect(_on_body_entered)


#Triggers dialogue when player enters
func _on_body_entered(_body: CharacterBody2D):
	if "Player" in Player:
		#Create copy of dialogue scene and push to the front of screen
		if dialogue_scene:
			var box = dialogue_scene.instantiate()
			get_tree().root.add_child(box)
			#Used if box has a setup
			if box.setup_method("setup"):
				box.setup(dialogue_text, character_portrait)
