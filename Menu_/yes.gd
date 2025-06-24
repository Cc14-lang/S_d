extends Button

var Painel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Painel = get_parent()
	pass # Replace with function body.

func _on_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
