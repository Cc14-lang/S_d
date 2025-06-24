extends Button

@onready var Audio = AudioServer
@onready var spritechild = self.get_child(0)
var toggle := false

func _on_pressed() -> void:
	toggle = !toggle 
	spritechild.visible = toggle
	Audio.set_bus_mute(Audio.get_bus_index("Master"), toggle)
