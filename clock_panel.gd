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
