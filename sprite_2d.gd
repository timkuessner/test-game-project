extends CharacterBody2D

@export var speed: float = 300.0
@export var acceleration: float = 1500.0
@export var friction: float = 2000.0
@export var jump_velocity: float = -450.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		
		sprite.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	move_and_slide()
