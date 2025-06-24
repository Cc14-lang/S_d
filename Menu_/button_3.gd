extends Button

@export var Can_Press = GlobalButton.Can_Press
var Painel_Sure
var Painel_Config
var audio
var Grow_Effect = Vector2(832.0,512.0)

func _ready() -> void:
	audio = $"../../UiClick"
	Painel_Sure = $"../../Menu_Saida";
	Painel_Config = $"../../Config_Painel"
	Painel_Config.visible = false;
	Painel_Config.size = Vector2.ZERO;
	await get_tree().create_timer(0.2).timeout;

func _process(delta: float) -> void:
		if Painel_Config.visible == true:
			Painel_Sure.visible = false
			Painel_Config.size = Painel_Config.size.lerp(Grow_Effect,0.15)
		else:
			Painel_Config.size = Vector2.ZERO
		
	
func _on_pressed() -> void:
	if Can_Press == true:
		audio.play()
		Painel_Config.visible = true
