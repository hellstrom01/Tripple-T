extends CharacterBody2D

@export var speed := 60.0
@export var max_hp := 3
var hp: int
var target: Node2D = null

func _ready() -> void:
	hp = max_hp
	add_to_group("enemies")  # so bullets can find/damage you

func set_target(t: Node2D) -> void:
	target = t

func _physics_process(delta: float) -> void:
	if target:
		var dir := (target.global_position - global_position)
		if dir.length() > 2.0: # don’t jitter on top of player
			velocity = dir.normalized() * speed
		else:
			velocity = Vector2.ZERO
	move_and_slide()

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		queue_free()  # enemy dies
