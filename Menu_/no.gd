extends Button
var Painel 
var audio 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Painel = get_parent()
	audio = $"../../UiReturn"
	pass # Replace with function body.


func _on_pressed() -> void:
	audio.play()
	Painel.visible = false
	pass # Replace with function body.
