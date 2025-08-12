extends Node2D

@onready var transition = $Transition
@onready var caixa = $Control
@onready var Fps_Label = preload("res://Fps-Layer.tscn")
var fps_in: Node = null

func _ready():
	if Global.togglefp:
		fps_in = Fps_Label.instantiate()
		get_tree().current_scene.add_child(fps_in)
	else:
		if fps_in:
			fps_in.queue_free()
			fps_in = null

	transition.play("Fade_to_Normal")
	await transition.animation_finished
	caixa.iniciar_dialogo([
		{"texto": "Desculpe a todos", "imagem": "res://Cutscene/Img_Cutscene/images.png"},
		{"texto": "Mais infelizmente não deu tempo de terminar", "imagem": "res://Cutscene/Img_Cutscene/Wip.webp"},
		{"texto": "Espero que compreendam", "imagem": "res://Cutscene/Img_Cutscene/images.png"},
	])
