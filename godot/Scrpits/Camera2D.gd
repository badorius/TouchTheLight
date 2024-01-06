extends Camera2D

@onready var player : CharacterBody2D = get_node("../Player")
@export var RandomStrength: float = 30.0
@export var ShakeFade: float = 5.0
@export var sum = 0

var rng = RandomNumberGenerator.new()
var shake_strenght: float  = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func apply_shake():
	shake_strenght = RandomStrength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sum = delta
	
func _physics_process(delta):
	global_position = player.global_position
	#position = lerp(position,player.position, 5 * delta)
	#print(player.global_position)
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strenght,shake_strenght),rng.randf_range(-shake_strenght,shake_strenght))
	
	
func shake_window():
	apply_shake()
	if shake_strenght > 0:
		shake_strenght = lerpf(shake_strenght,0,ShakeFade * sum)
		offset = randomOffset()
	
