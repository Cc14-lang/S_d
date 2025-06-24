extends Button

@export var Can_Press = false
@onready var transition = $"../../Transition"
@onready var color_rect = $"../../Transition/ColorRect"
var cutscene_scene = preload("res://Cutscene/cutscene_intro.tscn")
var audio

func _ready() -> void:
	audio = $"../../UiClick"
	
func _on_pressed() -> void:
	if Can_Press == true:
		audio.play()
		color_rect.visible = true
		transition.play("Fade_To_Black")
		
func _on_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name:
		get_tree().change_scene_to_packed(cutscene_scene)
	
