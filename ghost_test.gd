extends Sprite2D

func ghosting():
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self,"self_modulate",Color(1,1,1,0),0.75)
	await tween_fade.finished
	queue_free()
	
func add_ghost():
	var ghost = self.duplicate()
	ghost.position = self.position
	ghost.scale = self.scale
	get_tree().current_scene.add_child(ghost)
	ghost.ghosting()

func _on_ghost_timer_timeout() -> void:
	add_ghost()
