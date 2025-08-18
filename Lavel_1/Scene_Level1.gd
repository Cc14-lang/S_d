extends Node2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@onready var Fps_Label = preload("res://Efeitos/Fps-Layer.tscn")
var fps_in: Node = null

func _ready() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	if Global.togglefp:
		fps_in = Fps_Label.instantiate()
		get_tree().current_scene.add_child(fps_in)
	else:
		if fps_in:
			fps_in.queue_free()
			fps_in = null
