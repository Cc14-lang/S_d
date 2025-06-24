extends AnimatedSprite2D

var setas = 0

func _ready() -> void:
	self.frame =  setas 
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("Cima"):
		setas = 2
	elif Input.is_action_pressed("Baixo"):
		setas = 4
	elif Input.is_action_pressed("Esquerda"):
		setas = 1
	elif Input.is_action_pressed("Direita"):
		setas = 3
	else:
		setas = 0
	
	self.frame = setas
