extends CharacterBody2D

@export var move_speed: float = 150.0
@export var jump_velocity: float = -350.0
@export var jump_cooldown: float = 0.4
@export var damage: int = 1
@export var knockback_force: float = 300.0

var player: Node2D = null
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var cooldown_timer: float = 0.0

func _ready() -> void:
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if player:
		var direction_x = sign(player.global_position.x - global_position.x)
		
		if is_on_floor():
			velocity.x = 0.0
			cooldown_timer -= delta
			
			if cooldown_timer <= 0.0:
				velocity.y = jump_velocity
				velocity.x = direction_x * move_speed
				cooldown_timer = jump_cooldown
		else:
			velocity.x = direction_x * move_speed
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() == player:
			hit_player()

func hit_player() -> void:
	var push_dir = sign(player.global_position.x - global_position.x)
	if push_dir == 0:
		push_dir = 1
	var knockback = Vector2(push_dir * knockback_force, -200.0)
	
	if player.has_method("take_damage"):
		player.take_damage(damage, knockback)
