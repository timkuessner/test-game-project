extends CharacterBody2D

var coins = 0
var herz = 6

@export var SPEED = 50.0
const JUMP_VELOCITY = -80.0
var rest_jump = 2

func getCoin():
	coins += 1
	$"../CanvasLayer/Label".text = "Coins: " + str(coins)
	
func updateHerz():
	if herz > 6:
		herz = 6
	if herz <= 0:
		get_tree().quit()
	$"../CanvasLayer/GridContainer/Panel".updateHerz(herz)
	$"../CanvasLayer/GridContainer/Panel2".updateHerz(herz - 2)
	$"../CanvasLayer/GridContainer/Panel3".updateHerz(herz - 4)

func removeHerz():
	herz -= 1
	updateHerz()

func addHerz():
	herz += 2
	updateHerz()
	
func _ready():
	updateHerz()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
		velocity += Vector2(0, 200) * delta
	else:
		if velocity != Vector2(0,0):
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
		rest_jump = 2
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
		
	if position.y > 60:
		position = Vector2(0,0)
		removeHerz()
	
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and rest_jump > 0:
		velocity.y = JUMP_VELOCITY
		rest_jump -=1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	check_spike_collision()
	move_and_slide()
	
func check_spike_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is TileMapLayer:
			# 1. Berechne die Position RELATIV zur TileMap (verhindert Koordinaten-Fehler)
			var local_collision_point = collider.to_local(collision.get_position())
			
			# 2. Drücke den Punkt 4 Pixel tief in die Kachel (verhindert "Luft"-Abfragen an Kanten)
			var target_point = local_collision_point - collision.get_normal() * 4.0
			
			# 3. Kachel-Koordinaten ermitteln
			var tile_pos = collider.local_to_map(target_point)
			var tile_data = collider.get_cell_tile_data(tile_pos)
			
			# 4. SICHERHEITSABFRAGE: Nur prüfen, wenn dort wirklich eine Kachel existiert!
			if tile_data != null:
				if tile_data.get_custom_data("is_deadly") == true:
					position = Vector2(0,0)
					removeHerz()
					break # Schleife beenden, um Doppel-Treffer im selben Frame zu verhindern
