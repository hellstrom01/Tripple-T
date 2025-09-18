extends CharacterBody2D

var movespeed = 250
@export var weapon_scene: PackedScene
var weapon: Node
var facing_dir = "down"

@onready var sprite = $AnimatedSprite2D

func _ready():
	weapon = weapon_scene.instantiate()
	add_child(weapon)   # Weapon follows the player
	weapon.owner = self # So weapon can access player’s position
	
	
func _physics_process(delta: float) -> void:
	
	var motion = Vector2()
	
	if Input.is_action_pressed("up"):
		motion.y -= 1
	if Input.is_action_pressed("down"):
		motion.y += 1

	if Input.is_action_pressed("left"):
		motion.x -= 1
	
	if Input.is_action_pressed("right"):
		motion.x += 1

	velocity = motion.normalized() * movespeed
	move_and_slide()
	
	if Input.is_action_pressed("LMB"):
		weapon.shoot()
	
	_update_facing_direction()
	_update_animation(motion)
	
	
func _update_facing_direction() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var to_mouse: Vector2 = (mouse_pos - global_position).normalized()
	var angle: float = to_mouse.angle() # Radians, 0 = right
	angle = wrapf(angle, -PI, PI)
	
	
	if angle >= -PI and angle < -2.0 * PI / 3.0:
		facing_dir = "left_up"
	elif angle >= -2.0 * PI / 3.0 and angle < -PI / 3.0:
		facing_dir = "up"
	elif angle >= -PI / 3.0 and angle < 0.0:
		facing_dir = "right_up"
	elif angle >= 0.0 and angle < PI / 3.0:
		facing_dir = "right_down"
	elif angle >= PI / 3.0 and angle < 2.0 * PI / 3.0:
		facing_dir = "down"
	else:
		facing_dir = "left_down"

func _update_animation(motion: Vector2) -> void:
	if motion == Vector2.ZERO:
		sprite.animation = "idle_" + facing_dir
	else:
		sprite.animation = "walk_" + facing_dir
	sprite.play()
	
	
	
	
