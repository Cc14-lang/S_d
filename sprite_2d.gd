extends Sprite2D

@export var Can_Press = false
var target = Vector2(152.0, 360.0)
var etarget = Vector2(32.0,-136.0)
var effect 

func _ready() -> void:
	effect = $"../TextureRect2"
	effect.position = Vector2(-520.0, -136.0)
	position = Vector2(-335.0, 360.0)
	await get_tree().create_timer(1).timeout
	effect.visible = true

func _process(delta: float) -> void:
	position = position.lerp(target, 0.05) 
	effect.position = effect.position.lerp(etarget, 0.05) 
