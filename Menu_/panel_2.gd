extends Panel

var Can_Press 
var tween = create_tween()
var buttonmove = create_tween()
var is_hover = false

func _ready() -> void:
	
	Can_Press = GlobalButton.Can_Press
	position = Vector2(-320, 0.0)
	
	$Button.connect("mouse_entered", self._on_button_mouse_entered.bind($Button))
	$Button.connect("mouse_exited", self._on_button_mouse_exited.bind($Button))
	$Button2.connect("mouse_entered", self._on_button_mouse_entered.bind($Button2))
	$Button2.connect("mouse_exited", self._on_button_mouse_exited.bind($Button2))
	$Button3.connect("mouse_entered", self._on_button_mouse_entered.bind($Button3))
	$Button3.connect("mouse_exited", self._on_button_mouse_exited.bind($Button3))
	
	await get_tree().create_timer(1).timeout
	
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, 0), 0.8)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_BACK)
	tween.finished.connect(_on_tween_finished)
	
func _on_tween_finished():
	
	Can_Press = true


func _on_button_mouse_entered(button) -> void:
	if Can_Press:
		buttonmove = create_tween()
		buttonmove.tween_property(button, "position",Vector2(10,button.position.y),0.3)


func _on_button_mouse_exited(button) -> void:
	if Can_Press:
		buttonmove = create_tween()
		buttonmove.tween_property(button, "position",Vector2(0,button.position.y),0.3)
