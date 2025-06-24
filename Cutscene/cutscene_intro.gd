extends Node2D

@onready var transition = $Transition
@onready var caixa = $Control

func _ready():
	transition.play("Fade_to_Normal")
	await transition.animation_finished
	caixa.iniciar_dialogo([
		{"texto": "Desculpe a todos", "imagem": "res://Cutscene/Img_Cutscene/images.png"},
		{"texto": "Mais infelizmente não deu tempo de terminar", "imagem": "res://Cutscene/Img_Cutscene/Wip.webp"},
		{"texto": "Espero que compreendam", "imagem": "res://Cutscene/Img_Cutscene/images.png"},
	])
