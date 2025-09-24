extends CharacterBody2D

@export var movespeed := 250.0
@export var weapon_scene: PackedScene

var weapon: Node2D
var facing_dir := "down"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_anchor: Node2D = $WeaponAnchor

func _ready() -> void:
	add_to_group("Player")
	
	if weapon_scene:
		weapon = weapon_scene.instantiate() as Node2D
		weapon_anchor.add_child(weapon)
		# Let weapon know about this player if needed
		if weapon.has_method("set_player"):
			weapon.set_player(self)

func _physics_process(delta: float) -> void:
	var motion := Vector2.ZERO
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

	if Input.is_action_pressed("LMB") and weapon and weapon.has_method("shoot"):
		weapon.shoot()
	elif Input.is_action_just_released("LMB") and weapon:
		weapon.release_trigger()
		


	_update_facing_direction()
	_update_animation(motion)
	_update_weapon_layer()

func _update_facing_direction() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var to_mouse: Vector2 = (mouse_pos - global_position).normalized()
	var angle: float = wrapf(to_mouse.angle(), -PI, PI)

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
	if not sprite.is_playing():
		sprite.play()

func _update_weapon_layer() -> void:
	if not weapon:
		return
	# Place gun behind player when aiming upwards
	var aiming_up := get_global_mouse_position().y < global_position.y
	weapon.z_index = -1 if aiming_up else 1
	sprite.z_index = 0
