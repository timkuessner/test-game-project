extends Camera2D

@export var player: Node2D

@export var maxpos: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (abs(player.position.x - position.x) > 10):
		var speed = 1
		if (abs(player.position.x - position.x) > 30):
			speed = 2
		 
		var pos = lerp(position.x, player.position.x, speed * delta)
		
		if pos < 0:
			pos = 0
		
		if pos > maxpos:
			pos = maxpos
		
		position.x = pos
