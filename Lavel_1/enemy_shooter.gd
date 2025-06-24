extends CharacterBody2D

@export var health = 100
@export var speed = 150.0
@export var stop_distance = 250.0
@export var shoot_cooldown = 0.1
@export var lose_sight_delay = 5.0
var bullet = preload("res://Efeitos/bullet.tscn")
var blood = preload("res://Efeitos/Blood.tscn")
@onready var mat = $Enemy_Shooter.material
@onready var target = $"../Player"
@onready var shoot_point = $Marker2D

var players_in_area: Array = []
var founded = false
var search = false
var lose_sight_timer = 0.0
var can_shoot = true
var shoot_timer = 0.0

func morrer():
	if blood:
		var blood_instance = blood.instantiate()
		blood_instance.global_position = global_position
		var direction = blood_instance.global_position - target.global_position
		blood_instance.rotation = direction.angle()
		get_parent().add_child(blood_instance)
	queue_free()

func _process(delta: float) -> void:
	if health <= 0:
		morrer()
		return
	
	if target == null:
		return

	var direction = target.global_position - global_position
	var distance = direction.length()

	if founded:
		
		if players_in_area.is_empty():
			lose_sight_timer += delta
			if lose_sight_timer >= lose_sight_delay:
				founded = false
				lose_sight_timer = 0.0
		else:
			lose_sight_timer = 0.0

		if distance > stop_distance:
			direction = direction.normalized()
			velocity = direction * speed
			move_and_slide()
			rotation = lerp_angle(rotation, direction.angle(), delta * 2)
			$Enemy_Shooter.play("Walk")
		else:
			velocity = Vector2.ZERO
			$Enemy_Shooter.stop()
			rotation = lerp_angle(rotation, direction.angle(), delta * 4)

			if can_shoot and target._Enable != false:
				shoot()
	else:
		$Enemy_Shooter.stop()
		velocity = Vector2.ZERO
		
		if search:
			rotation = lerp_angle(rotation, -direction.angle(), delta * 2)

	if not can_shoot:
		shoot_timer += delta
		if shoot_timer >= shoot_cooldown:
			can_shoot = true
			shoot_timer = 0.0

func shoot():
	if bullet:
		can_shoot = false
		var b = bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.global_position = shoot_point.global_position
		b.rotation = shoot_point.global_rotation

func _on_d_area_body_entered(body: Node2D) -> void:
	if body == target and not players_in_area.has(body):
		players_in_area.append(body)
		founded = true
		search = true

func _on_d_area_body_exited(body: Node2D) -> void:
	if body == target and players_in_area.has(body):
		players_in_area.erase(body)
