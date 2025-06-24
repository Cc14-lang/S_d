extends TextureRect

var sprite 

func _ready() -> void:
	sprite = $"../Sprite2D"
	
func _process(delta: float) -> void:
	
	position = sprite.position
