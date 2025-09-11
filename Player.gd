extends CharacterBody2D

var movespeed = 500
@onready var sprite = $AnimatedSprite2D

func _ready():
	pass
	
	
func _physics_process(delta: float) -> void:
	var motion = Vector2()
	
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
	_update_animation(motion)
	
	

func _update_animation(motion: Vector2) -> void:
	if motion == Vector2.ZERO:
		# Player is idle, keep last direction
		match sprite.animation:
			"walk_up":
				sprite.animation = "idle_up"
			"walk_down":
				sprite.animation = "idle_down"
			"walk_left_up":
				sprite.animation = "idle_left_up"
			"walk_right_up":
				sprite.animation = "idle_right_up"
			"walk_left_down":
				sprite.animation = "idle_left_down"
			"walk_right_down":
				sprite.animation = "idle_right_down"
		sprite.play()
		return
		
	if motion.x > 0:
		if motion.y < 0:
			sprite.animation = "walk_right_up"
		else:
			sprite.animation = "walk_right_down"
			
	elif motion.x < 0:
		if motion.y < 0:
			sprite.animation = "walk_left_up"
		else:
			sprite.animation = "walk_left_down"
			
	else:
		if motion.y < 0:
			sprite.animation = "walk_up"
		else:
			sprite.animation = "walk_down"
	
	sprite.play()
	

	
	
	
	
	
