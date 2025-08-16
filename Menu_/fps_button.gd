extends Button

@onready var spritechild = get_child(0)
@onready var Fps_Label = preload("res://Efeitos/Fps-Layer.tscn")
var fps_in: Node = null

func _on_pressed() -> void:
	Global.togglefp = !Global.togglefp
	spritechild.visible = Global.togglefp

	if Global.togglefp:
		fps_in = Fps_Label.instantiate()
		get_tree().current_scene.add_child(fps_in)
		
	else:
		if fps_in:
			fps_in.queue_free()
			fps_in = null
