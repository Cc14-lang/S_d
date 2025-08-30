extends Camera2D

@onready var Player = $"../Player" as CharacterBody2D
@onready var Shadow_Layer = $Sh_Layer/Shadow
var level_Health = [
	{"range": range(76, 100), "color": Color(0.0, 0.416, 0.0)},
	{"range": range(26, 75),  "color": Color(0.582, 0.393, 0.0)},
	{"range": range(0, 25),   "color": Color(0.4, 0.0, 0.0)}     
]
var Health_Text
var target_color : Color = Color.WHITE
var lerp_value := 0.1
var Default = Vector2(1.9 , 1.9) 
var a = Color(1.0, 1.0, 1.0, 0.4)
var b = Color(1.0, 1.0, 1.0, 0.953)
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
		Health_Text.text = str(Player.health.current)
		for level in level_Health:
			if Player.health.current in level["range"]:
				Health_Text.modulate = level["color"]
				break
	if Player._Enable == false:
		Health_Text.text = "Ts pmo😭🥀🥀"
	else:
		zoom = zoom.lerp(target_zoom, lerp_value)
