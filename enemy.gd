extends CharacterBody2D

@export var move_speed: float = 150.0
@onready var player: CharacterBody2D = $"../Player"

func _physics_process(delta: float) -> void:
	# Apply gravity so the enemy walks on the ground without jumping
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Walk left or right toward the player
	if player:
		var direction_x = sign(player.global_position.x - global_position.x)
		velocity.x = direction_x * move_speed

	move_and_slide()

	# Check if the enemy touched the player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() == player:
			print("Enemy touched the player!")
