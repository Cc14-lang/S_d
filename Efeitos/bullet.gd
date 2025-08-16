extends Area2D

var speed = 1350

func _physics_process(delta):
	position += transform.x * speed * delta
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.health -= 50
		var mats = []
		for sprite_name in ["BodySprite", "Enemy_Shooter", "Enemy_Runner"]:
			if body.has_node(sprite_name):
				var mat = body.get_node(sprite_name).material
				if mat:
					mat.set("shader_parameter/hit_effect", 1.0)
					await get_tree().create_timer(0.2).timeout
					mat.set("shader_parameter/hit_effect", 0.0)
		queue_free()
	elif body is TileMapLayer:
		queue_free()
		

func _on_timer_timeout() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
