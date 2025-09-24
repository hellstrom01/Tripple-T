extends Node2D

@onready var player := $Player
const EnemyScene := preload("res://Enemy.tscn")

func _ready() -> void:
	# Ee: spawn one near the player at start
	print("hello")
	spawn_enemy_near_player(200.0, 350.0)

func spawn_enemy_near_player(min_dist := 200.0, max_dist := 350.0) -> Node2D:
	var tries := 12
	while tries > 0:
		var angle: float = randf() * TAU
		var dist: float = randf_range(min_dist, max_dist)
		var pos: Vector2 = player.global_position + Vector2.RIGHT.rotated(angle) * dist
		
		print(player.global_position)

		if _is_position_free(pos):
			var e: Node2D = EnemyScene.instantiate()
			e.global_position = pos
			add_child(e)
			if e.has_method("set_target"):
				e.set_target(player)
			return e
		tries -= 1
	return null  # couldn't find a free spot this time

func _is_position_free(pos: Vector2) -> bool:
	var shape := CircleShape2D.new()
	shape.radius = 14.0  # roughly your enemy's "half-size"

	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D(0.0, pos)
	# Make this match what you want to avoid: usually walls/statics/enemies/player.
	# 0xFFFFFFFF means "check against everything".
	params.collision_mask = 0xFFFFFFFF

	var space := get_world_2d().direct_space_state
	var hits := space.intersect_shape(params, 1)
	return hits.is_empty()
	
	
