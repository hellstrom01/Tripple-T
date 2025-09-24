extends Area2D

@export var speed := 600.0
@export var lifetime := 1.5
@export var damage := 1
@export var pierce_count: int = 1  # Hits before stopping (1 = no pierce)

var current_pierce: int

func _ready() -> void:
	current_pierce = pierce_count  # Copy export to runtime var
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	# Signal connection (with duplicate check, from earlier)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and current_pierce > 0:
		body.take_damage(damage)
		current_pierce -= 1
		if current_pierce <= 0:
			queue_free()
