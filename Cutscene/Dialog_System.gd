extends Control

@onready var label = $Panel/DialogueLabel
@onready var imagem = $"../Sprite2D"
@onready var transition = $"../Transition"
var level1 = preload("res://node_2d.tscn")

var falas = []
var index = 0
var ativo = false

var texto_completo = ""
var texto_mostrado = ""
var texto_index = 0
var texto_digitando = false
var texto_velocidade = 0.05
var timer = 0.0

func _ready():
	hide()

func iniciar_dialogo(lista_de_falas):
	falas = lista_de_falas
	index = 0
	ativo = true
	show()
	mostrar_fala()

func mostrar_fala():
	var fala = falas[index]
	texto_completo = fala.get("texto", "")
	texto_mostrado = ""
	texto_index = 0
	texto_digitando = true
	label.text = ""
	timer = 0.0
	
	if fala.has("imagem"):
		imagem.scale = Vector2(1.267,0.545)
		imagem.texture = load(fala["imagem"])

func _process(delta):
	if ativo:
		if texto_digitando:
			timer += delta
			if timer >= texto_velocidade:
				timer = 0.0
				texto_index += 1
				texto_mostrado = texto_completo.substr(0, texto_index)
				label.text = texto_mostrado

				if texto_index >= texto_completo.length():
					texto_digitando = false
		else:
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("Mouse_Esquerdo"):
				index += 1
				if index < falas.size():
					mostrar_fala()
				else:
					ativo = false
					imagem.queue_free()
					hide()
					transition.play("Fade_To_Black")
					await transition.animation_finished
					get_tree().change_scene_to_packed(level1)
					
