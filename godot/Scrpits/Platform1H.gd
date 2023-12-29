extends TileMap
var base_position = 4178
var top_position = 4573
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction == 1:
		if position.x < top_position:
			position.x += 1
		else:
			direction =-1
			
	elif direction == -1:
		if position.x > base_position:
			position.x -= 1
			
		else:
			direction = 1
