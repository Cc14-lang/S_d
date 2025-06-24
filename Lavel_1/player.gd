extends Area2D

@export var speed = 20
@export var _Enable = true

var screen_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _Enable == true:
		var velocity = Vector2.ZERO
		if Input.is_action_pressed("Cima"):
			velocity.y -= 1
			print("Cima")
		if Input.is_action_pressed("Baixo"):
			velocity.y += 1
			print("Baixo")
		if Input.is_action_pressed("Direita"):
			velocity.x += 1
			print("Direita")
		if Input.is_action_pressed("Esquerda"):
			velocity.x -= 1
			print("Esquerda")

		# Movimento e animação
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			position = lerp(position, position + velocity * delta, 12.0)
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.stop()

		# Rotação em direção ao mouse
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).angle()
		rotation = lerp_angle(rotation, direction, delta * 5)
