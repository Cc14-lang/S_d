extends Button

var Config_Painel
var audio

func _ready() -> void:
	audio = $"../../UiReturn"
	Config_Painel = get_parent()
	
func _on_pressed() -> void:
	audio.play()
	Config_Painel.visible = not true
