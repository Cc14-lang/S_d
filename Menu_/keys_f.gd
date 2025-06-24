extends AnimatedSprite2D
var setas = 0

func _ready() -> void:
	self.frame =  setas 
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("Zoom"):
		setas = 2
	else:
		setas = 0
	
	self.frame = setas
