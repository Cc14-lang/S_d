extends TextureRect

var tween = create_tween()

func _ready() -> void:
	position = Vector2(-460, -136.0)
	
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(32.0, -136.0), 1)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
	tween.finished.connect(_tween_finished)
	
func _tween_finished():
	tween.stop()
