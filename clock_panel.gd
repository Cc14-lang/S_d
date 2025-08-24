extends Panel

@onready var mm = self.get_child(0)
@onready var ss = self.get_child(1)
var time: float = 0


func _process(delta: float) -> void:
	time += delta
	var tss = int(fmod(time, 60))
	var tmm = int(time / 60)

	mm.text = "%02d:" % tmm
	ss.text = "%02d" % tss


func _on_mouse_entered() -> void:
	var buttonmove = create_tween()
	buttonmove.tween_property(self, "position", Vector2(1173, self.position.y), 0.3)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_BACK)

func _on_mouse_exited() -> void:
	var buttonmove = create_tween()
	buttonmove.tween_property(self, "position", Vector2(1261.0, self.position.y), 0.3)
