extends Button

@onready var spritechild = self.get_child(0)
@onready var Fps_Label = $"../../Fps"

var toggle := false

func _on_pressed() -> void:
	toggle = !toggle 
	spritechild.visible = toggle
	Fps_Label.visible = toggle
	
func _process(delta: float) -> void:
	Fps_Label.text = str(int(Engine.get_frames_per_second()))
	
