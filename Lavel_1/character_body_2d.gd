extends CharacterBody2D

@export var health = 100
@export var speed = 250
@export var _Enable = true
@export var lerp_smooth = 10	
@onready var hitbox = $Hitbox_Area/Hitbox
@onready var timerlabel = $"../Camera2D/Timer_Layer"
@onready var Ghost_Timer = $Ghost_Timer
@export var shoot_cooldown = 3
var roll_cooldown = 4.0
var roll_timer = 0.0
var can_roll = true
var can_shoot = true
var blood = preload("res://Efeitos/Blood.tscn")
var bullet = preload("res://Efeitos/bullet.tscn")
var screen_size
var respawn = Vector2(648.0 , 488.0)
@onready var mat = $BodySprite.material 


func _Stab():
	hitbox.disabled = false
	hitbox.debug_color = Color(0.865, 0.001, 0.864, 0.42)
	$Arm_Right_Sprite.play("Stab")
	await get_tree().create_timer(0.5).timeout
	$Arm_Right_Sprite.stop()
	hitbox.disabled = true
	hitbox.debug_color = Color(0.969, 0.0, 0.965, 0.094)


func _morto():
	self._Enable = false
	mat.set("shader_parameter/hit_effect", 0.0)
	$Arm_Left_Sprite.visible = false
	$Arm_Right_Sprite.visible = false
	hitbox.disabled = true
	if blood:
		var blood_instance = blood.instantiate()
		blood_instance.global_position = global_position
		blood_instance.rotation = rotation + PI
		get_parent().add_child(blood_instance)
	

func _respawn():
	self._Enable = true
	self.position = respawn
	get_tree().reload_current_scene()
	

func _Roll():
	if not can_roll:
		return
	can_roll = false
	Ghost_Timer.start()
	var mouse_pos = get_global_mouse_position()
	var dir_vector = (mouse_pos - global_position).normalized()
	self.velocity = dir_vector * speed * 4
	await get_tree().create_timer(0.4).timeout
	Ghost_Timer.stop()
	self.velocity = Vector2.ZERO


func add_ghost():
	var ghost = $BodySprite.duplicate() as AnimatedSprite2D
	ghost.position = global_position
	ghost.scale = Vector2(0.25,0.25)
	ghost.self_modulate = Color(1,1,1,1) 
	var mouse_pos = get_global_mouse_position()
	ghost.rotation = (mouse_pos - global_position).angle()
	ghost.rotate(-80)
	get_tree().current_scene.add_child(ghost)
	ghost.show()
	var tween = get_tree().create_tween()
	tween.tween_property(ghost, "self_modulate", Color(1,1,1,0), 0.7)
	tween.finished.connect(Callable(ghost, "queue_free"))


func _on_ghost_timer_timeout() -> void:
	add_ghost()


func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	
	var b = bullet.instantiate()
	get_tree().current_scene.add_child(b)
	b.global_position = $Marker2D.global_position
	b.global_rotation = $Marker2D.global_rotation
	$Arm_Left_Sprite.play("Shoot")
	await get_tree().create_timer(shoot_cooldown).timeout
	$Arm_Left_Sprite.stop()
	can_shoot = true


func _ready() -> void:
	screen_size = get_viewport_rect().size
	mat.set("shader_parameter/hit_effect", 0.0)
	timerlabel.visible = false
	

func _physics_process(delta: float) -> void:
	if _Enable == true:
		var velocity = Vector2.ZERO
		
		if Input.is_action_pressed("Cima"):
			velocity.y -= 1

		if Input.is_action_pressed("Baixo"):
			velocity.y += 1

		if Input.is_action_pressed("Direita"):
			velocity.x += 1

		if Input.is_action_pressed("Esquerda"):
			velocity.x -= 1

		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$BodySprite.play("Walk")
		else:
			velocity = Vector2.ZERO
			$BodySprite.stop()
		self.velocity = self.velocity.lerp(velocity, delta * lerp_smooth)
		move_and_slide()
		
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).angle()
		rotation = lerp_angle(rotation, direction, delta * 8)
		
		if Input.is_action_just_pressed("Mouse_Direito"):
			_Stab()
		
		if Input.is_action_just_pressed("Mouse_Esquerdo"):
			shoot()
			
		if Input.is_action_just_pressed("Tecla_E"):
			if not can_roll:
				return
			_Roll()
		
	if health <= 0: 
		_morto()
		if Input.is_action_just_pressed("Enter"):
			health = 100
			_respawn()
			
	if not can_roll:
		roll_timer += delta
		var time_left = roll_cooldown - roll_timer
		if time_left < 0:
			time_left = 0
			roll_timer = 0
			can_roll = true
			timerlabel.visible = false
		else:
			timerlabel.visible = true
			timerlabel.get_child(0).text = "%.1f s" % time_left
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.get_meta("Class") == "Enemy":
			body.health -= 25
			var mat_Enemy = body.material
			if mat_Enemy and mat_Enemy is ShaderMaterial:
				mat_Enemy.set("shader_parameter/hit_effect", 1.0)
				await get_tree().create_timer(0.2).timeout
				mat_Enemy.set("shader_parameter/hit_effect", 0.0)
			await get_tree().create_timer(1).timeout
