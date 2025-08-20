extends CharacterBody2D

@export var health = 100
@export var speed = 250
@export var _Enable = true
@export var lerp_smooth = 10
@onready var hitbox = $Hitbox_Area/Hitbox
@onready var timerlabel = $"../Camera2D/Timer_Layer"
@onready var shootlabel = $"../Camera2D/Timer_Layer2"
@onready var Ghost_Timer = $Ghost_Timer
@onready var Pistol = $Arm_Left_Sprite
@onready var Male = $Arm_Right_Sprite
@export var shoot_cooldown = 2.0
@export var beat_cooldown = 0.5
@export var can_shoot = true
@export var can_beat = true
var can_roll = true
var roll_cooldown = 4.0
var roll_timer = 0.0
var shoot_timer = 0.0
var blood = preload("res://Efeitos/Blood.tscn")
var bullet = preload("res://Efeitos/bullet.tscn")
var screen_size
var respawn = Vector2(648.0 , 488.0)
@onready var mat = $BodySprite.material

var Inventary = 1  

func _Stab():
	if can_beat:
		can_beat = false
		hitbox.disabled = false
		hitbox.debug_color = Color(0.865, 0.001, 0.864, 0.42)
		Male.play("Stab")
		await get_tree().create_timer(beat_cooldown).timeout
		Male.stop()
		can_beat = true
		hitbox.disabled = true
		hitbox.debug_color = Color(0.969, 0.0, 0.965, 0.094)

func _DemageEffect(a,t,b):
	mat.set("shader_parameter/hit_effect", a)
	await get_tree().create_timer(t).timeout
	mat.set("shader_parameter/hit_effect", b)

func _morto():
	_Enable = false
	var Lab = $"O-screen/R_Key"
	Lab.visible = true
	Lab.position = position + Vector2(-63,-35)
	mat.set("shader_parameter/hit_effect", 0.0)
	Pistol.visible = false
	Male.visible = false
	hitbox.disabled = true
	if blood:
		var blood_instance = blood.instantiate()
		blood_instance.global_position = global_position
		blood_instance.rotation = rotation + PI
		get_parent().add_child(blood_instance)

func _respawn():
	_Enable = true
	position = respawn
	get_tree().reload_current_scene()

func _Roll():
	if not can_roll:
		return
	can_roll = false
	Ghost_Timer.start()
	var mouse_pos = get_global_mouse_position()
	var dir_vector = (mouse_pos - global_position).normalized()
	velocity = dir_vector * speed * 4
	await get_tree().create_timer(0.4).timeout
	Ghost_Timer.stop()
	velocity = Vector2.ZERO

func add_ghost():
	var ghost = $BodySprite.duplicate() as AnimatedSprite2D
	ghost.position = global_position
	ghost.scale = Vector2(0.25,0.25)
	ghost.self_modulate = Color(1,1,1,1)
	var mouse_pos = get_global_mouse_position()
	ghost.rotation = (mouse_pos - global_position).angle()
	ghost.rotate(-80)
	get_tree().current_scene.add_child(ghost)
	var tween = get_tree().create_tween()
	tween.tween_property(ghost, "self_modulate", Color(1,1,1,0), 0.7)
	tween.finished.connect(Callable(ghost, "queue_free"))

func _on_ghost_timer_timeout() -> void:
	add_ghost()

func _MaleEquip():
	can_beat = true
	Male.visible = true
	Pistol.visible = false

func _PistolEquip():
	can_beat = false
	Male.visible = false
	Pistol.visible = true

func shoot():
	var b = bullet.instantiate()
	get_tree().current_scene.add_child(b)
	if $Marker2D:
		b.global_position = $Marker2D.global_position
		b.global_rotation = $Marker2D.global_rotation
	else:
		b.global_position = global_position
		b.global_rotation = rotation
	if $Arm_Left_Sprite:
		$Arm_Left_Sprite.play("Shoot")

func _ready() -> void:
	screen_size = get_viewport_rect().size
	Inventary = 0
	mat.set("shader_parameter/hit_effect", 0.0)
	shootlabel.visible = false
	timerlabel.visible = false

func _physics_process(delta: float) -> void:
	if _Enable:
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

		if Input.is_action_just_pressed("Equip_1"):
			Inventary = 1
			_MaleEquip()
		if Input.is_action_just_pressed("Equip_2"):
			Inventary = 2
			_PistolEquip()
			
		if Input.is_action_just_pressed("Equip_3"):
			Inventary = 0
			can_shoot = false
			can_beat = false
			Pistol.visible = false
			Male.visible = false
			shootlabel.visible = false 

		if Input.is_action_just_pressed("Mouse_Esquerdo"):
			match Inventary:
				1:
					if can_beat:
						_Stab()
				2:
					if can_shoot:
						shoot()
						can_shoot = false
						shoot_timer = 0.0

		if Input.is_action_just_pressed("Tecla_E"):
			if can_roll:
				_Roll()

	if health <= 0:
		_morto()
		if Input.is_action_just_pressed("Enter"):
			health = 100
			_respawn()

	if not can_roll:
		roll_timer += delta
		var time_left = roll_cooldown - roll_timer
		if time_left <= 0:
			can_roll = true
			roll_timer = 0.0
			timerlabel.visible = false
		else:
			timerlabel.visible = true
			timerlabel.get_child(0).text = "%.1f s" % time_left

	if not can_shoot:
		shoot_timer += delta
		var shoot_left = shoot_cooldown - shoot_timer
		if shoot_left <= 0:
			can_shoot = true
			shoot_timer = shoot_cooldown 
		if Inventary == 2:
			shootlabel.visible = true
			shootlabel.get_child(0).text = "%.1f s" % shoot_left
		else:
			shootlabel.visible = false
	else:
		shootlabel.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.get_meta("Class") == "Enemy":
			body.health -= 25
			body._DemageEffect(0.6, 0.2, 0.0)
