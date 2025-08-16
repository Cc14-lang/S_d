extends Camera2D

@onready var Player = $"../Player" as CharacterBody2D
var Health_Text
var Default = Vector2(1.9 , 1.9)
var lerp_value = 0.1
var Extende = Vector2(1.4,1.4)
var target_zoom

func _ready() -> void:
	Health_Text = $Health_Layer/Health_Img/Helth_Number
	
	target_zoom = Default
	zoom = Default

func _process(delta: float) -> void:
	position = Player.position  

	if Input.is_action_just_pressed("Zoom"):
		target_zoom = Extende
	elif Input.is_action_just_released("Zoom"):
		target_zoom = Default
	
	if Player:
		Health_Text.text = str(Player.health)
	
	if Player._Enable == false:
		Health_Text.text = "Ts pmo😭🥀🥀"
	else:
		zoom = zoom.lerp(target_zoom, lerp_value)
	
