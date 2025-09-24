extends Area2D

@export var target_scene_path: String = "res://scenes/worlds/world.tscn"  # e.g., "res://scenes/shotgun_test.tscn" – set in Inspector
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var prompt_text: String = "Press E to Enter"  # Custom text here!
@onready var prompt_label: Label = get_node("/root/MainHub/UI/PromptContainer/PromptLabel")

var player_inside: Node2D = null

func _ready():
	prompt_label.visible = false
	if target_scene_path.is_empty():
		push_error("Set target_scene_path in Inspector!")

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		player_inside = body
		prompt_label.text = prompt_text  # Write the text!
		prompt_label.visible = true     # Show it

func _on_body_exited(body: Node2D):
	if body == player_inside:
		player_inside = null
		prompt_label.visible = false     # Hide it

func _input(event):
	if player_inside and event.is_action_pressed("interact"):
		_enter_door()

func _enter_door():
	if get_tree().change_scene_to_file(target_scene_path) != OK:
		push_error("Failed to load scene: " + target_scene_path)
