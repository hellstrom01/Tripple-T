extends Area2D

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Enemy":
		queue_free()
