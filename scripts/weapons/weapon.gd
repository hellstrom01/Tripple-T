extends Node2D
# General weapon base for Godot 4.5 (pistol/auto/shotgun)

@export var bullet_scene: PackedScene

# Fire behavior
@export var fire_rate := 8.0          # shots per second
@export var automatic := true         # true = hold-to-fire, false = semi-auto (one shot per press)
@export var pellets := 1              # shotgun: >1
@export var spread_deg := 0.0         # random spread cone (degrees)

# Ballistics / feel
@export var bullet_speed := 1000.0
@export var damage := 10
@export var recoil_pixels := 5.0
@export var recoil_time := 0.08

# Nodes (scene structure must be: Weapon -> Visual -> (GunSprite, Muzzle -> MuzzleFlash))
@onready var visual: Node2D = $Visual
@onready var gun_sprite: Sprite2D = $Visual/GunSprite
@onready var muzzle: Marker2D = $Visual/Muzzle
@onready var muzzle_flash: Sprite2D = $Visual/Muzzle/MuzzleFlash
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var fire_timer: Timer = $FireTimer

var player: Node2D
var recoil_tween: Tween
var flash_tween: Tween

# Semi-auto trigger lock
var _trigger_locked := false


func set_player(p: Node2D) -> void:
	player = p

func _ready() -> void:
	fire_timer.one_shot = true
	fire_timer.wait_time = 1.0 / max(0.01, fire_rate)
	visual.scale = Vector2.ONE

func _process(delta: float) -> void:
	_aim_at_mouse()

func _aim_at_mouse() -> void:
	var to_mouse := get_global_mouse_position() - global_position
	rotation = to_mouse.angle()  # rotate whole weapon
	# Flip whole visual when aiming left so sprite isn't upside down
	var left_side = abs(rad_to_deg(rotation)) > 90.0
	visual.scale.y = -1.0 if left_side else 1.0

# Call this every frame while fire input is held (Player handles input).
# For semi-auto, also call release_trigger() when button is released.
func shoot() -> void:
	if not automatic and _trigger_locked:
		return
	if fire_timer.is_stopped():
		_fire_once()
		fire_timer.start()
		if not automatic:
			_trigger_locked = true

func release_trigger() -> void:
	_trigger_locked = false

func _fire_once() -> void:
	if not bullet_scene:
		return

	var base_dir := (get_global_mouse_position() - muzzle.global_position).normalized()

	for i in pellets:
		var offset_rad := deg_to_rad(randf_range(-spread_deg * 0.5, spread_deg * 0.5))
		var dir := base_dir.rotated(offset_rad)

		var bullet := bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.speed = bullet_speed
		bullet.global_position = muzzle.global_position
		bullet.rotation = dir.angle()
		if "velocity" in bullet:
			bullet.velocity = dir * bullet_speed
		if "damage" in bullet:
			bullet.damage = damage

	if shoot_sound and shoot_sound.stream:
		shoot_sound.pitch_scale = randf_range(0.97, 1.03)
		shoot_sound.play()

	_play_muzzle_flash()
	_play_recoil()

func _play_muzzle_flash() -> void:
	if not muzzle_flash:
		return
	muzzle_flash.visible = true
	var t = create_tween()
	t.tween_interval(0.05)  # show briefly
	t.tween_callback(func (): muzzle_flash.visible = false)



func _play_recoil() -> void:
	if recoil_tween and recoil_tween.is_running():
		recoil_tween.kill()
	var dir := Vector2.RIGHT.rotated(rotation)  # gun art points right by default
	var out_pos := -dir * recoil_pixels
	recoil_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	recoil_tween.tween_property(self, "position", out_pos, recoil_time * 0.5)
	recoil_tween.tween_property(self, "position", Vector2.ZERO, recoil_time * 0.5)
