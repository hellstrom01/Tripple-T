extends Area2D

@export var speed := 600.0
@export var lifetime := 1.5
@export var damage := 1

func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		queue_free()
