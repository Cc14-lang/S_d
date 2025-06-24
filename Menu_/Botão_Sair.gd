extends Button

@export var Can_Press = GlobalButton.Can_Press
var Painel_Sure
var Painel_Config
var audio
var Grow_Effect = Vector2(256.00,88.0)

func _ready() -> void:
	audio = $"../../UiClick"
	Painel_Sure = $"../../Menu_Saida";
	Painel_Config = $"../../Config_Painel"
	Painel_Sure.visible = false;
	Painel_Sure.size = Vector2.ZERO;
	await get_tree().create_timer(0.2).timeout;

func _process(delta: float) -> void:
		if Painel_Sure.visible == true:
			Painel_Config.visible = false
			Painel_Sure.size = Painel_Sure.size.lerp(Grow_Effect,0.15)
		else:
			Painel_Sure.size = Vector2.ZERO
			pass
		
	
func _on_pressed() -> void:
	if Can_Press == true:
		audio.play()
		Painel_Sure.visible = true
