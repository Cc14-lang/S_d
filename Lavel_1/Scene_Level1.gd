extends Node2D

@onready var Fps_Label = preload("res://Fps-Layer.tscn")
var fps_in: Node = null

func _ready() -> void:
	if Global.togglefp:
		fps_in = Fps_Label.instantiate()
		get_tree().current_scene.add_child(fps_in)
	else:
		if fps_in:
			fps_in.queue_free()
			fps_in = null
