extends CharacterBody2D

@export var health = 100
@export var speed = 200.0
@export var stop_distance = 35
@export var lose_sight_delay = 2.0  
@export var attack_cooldown = 0.5

var blood = preload("res://Efeitos/Blood.tscn")

@onready var Hitbox = $E_Area/E_Hitbox
@onready var target = $"../Player"
@onready var mat = $Enemy_Runner.material
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var search = false
var founded = false
var players_in_area = []
var lose_sight_timer = 0.0
var can_attack = true
var attack_timer = 0.0

func morrer():
	if blood:
		var blood_instance = blood.instantiate()
		blood_instance.global_position = global_position
		var direction = blood_instance.global_position - target.global_position
		blood_instance.rotation = direction.angle()
		get_parent().add_child(blood_instance)
	queue_free()

func _ready() -> void:
	health = 100
	Hitbox.disabled = false
	mat.set("shader_parameter/hit_effect", 0.0)
	
	nav_agent.target_desired_distance = stop_distance
	nav_agent.max_speed = speed

func _process(delta: float) -> void:
	if health <= 0:
		morrer()
		return
	
	if target == null:
		return

	var distance_to_target = global_position.distance_to(target.global_position)

	if founded:
		$Attentation.play("Target_Subject")
		if players_in_area.is_empty():
			lose_sight_timer += delta
			if lose_sight_timer >= lose_sight_delay:
				$Attentation.stop()
				founded = false
				lose_sight_timer = 0.0
		else:
			lose_sight_timer = 0.0

		nav_agent.target_position = target.global_position

		if not nav_agent.is_navigation_finished():
			var next_position = nav_agent.get_next_path_position()
			var direction = (next_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
			rotation = lerp_angle(rotation, direction.angle(), delta * 4)
			$Enemy_Runner.play("Walk")
			can_attack = false
		else:
			velocity = Vector2.ZERO
			$Enemy_Runner.stop()
			var direction_to_target = (target.global_position - global_position).normalized()
			rotation = lerp_angle(rotation, direction_to_target.angle(), delta * 4)

			if can_attack and not players_in_area.is_empty() and target._Enable != false:
				_attack()
				can_attack = false
				attack_timer = 0.0
	else:
		velocity = Vector2.ZERO
		$Enemy_Runner.stop()
		if search:
			var direction_to_target = -(target.global_position - global_position).normalized()
			rotation = lerp_angle(rotation, -direction_to_target.angle(), delta * 2)

	if not can_attack:
		attack_timer += delta
		if attack_timer >= attack_cooldown:
			can_attack = true

func _attack() -> void:
	if target:
		$Arm_Runner.play("Stab")
		target.health -= 20
		Hitbox.debug_color = Color(0.865, 0.001, 0.864, 0.42)
		await get_tree().create_timer(0.3).timeout
		$Arm_Runner.stop()
		Hitbox.debug_color = Color(0.969, 0.0, 0.965, 0.094)

func _on_e_area_body_entered(body: Node2D) -> void:
	if body == target and founded and can_attack:
		pass

func _on_d_area_body_entered(body: Node2D) -> void:
	if body == target and not players_in_area.has(body):
		players_in_area.append(body)
		founded = true
		search = true

func _on_d_area_body_exited(body: Node2D) -> void:
	if body == target and players_in_area.has(body):
		players_in_area.erase(body)
