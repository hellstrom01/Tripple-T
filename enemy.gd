extends CharacterBody2D

@export var speed := 60.0
@export var target_path: NodePath   # drag your Player node here in the Inspector
var target: Node2D

func _ready() -> void:
	if target_path != NodePath():
		target = get_node(target_path)

func _physics_process(delta: float) -> void:
	if target:
		var dir := (target.global_position - global_position)
		if dir.length() > 2.0:               # small stop radius so it doesn’t jitter
			velocity = dir.normalized() * speed
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
	move_and_slide()
