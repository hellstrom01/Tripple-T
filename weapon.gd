extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate := 0.1
@export var bullet_speed := 1000.0

@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound

var time_since_last_shot := 0.0

func _process(delta: float) -> void:
	time_since_last_shot += delta

func shoot() -> void:
	if time_since_last_shot < fire_rate:
		return
	time_since_last_shot = 0.0
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	# Start bullet in front of player
	bullet.global_position = owner.global_position
	
	# Aim at mouse
	var dir = (get_global_mouse_position() - owner.global_position).normalized()
	bullet.velocity = dir * bullet_speed
	bullet.rotation = dir.angle()
	
	if shoot_sound.stream:
		shoot_sound.play()
