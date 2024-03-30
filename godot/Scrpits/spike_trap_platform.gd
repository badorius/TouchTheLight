extends Area2D
var maxup = 1000
var maxdown = 1000
#Vars to Wave y movement
var bob_height : float = 200.0
var bob_speed : float = 4.0
@onready var start_y : float = global_position.y
var t : float = 0.0
const attack_power : int = 50

var SpikeDown : AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SpikeDown = $SpikeDown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		# increase 't' over time.
		t += delta
		
		# creloopate a sin wave that bobs up and down.
		var d = (sin(t * bob_speed) + 1) / 2
		
		# apply that to  Y position.
		global_position.y = start_y + (d * bob_height)
		
		
		# 0.99977890153385 0002054421772
		if d >= 0.99977890153385:
			SpikeDown.play()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.hurt(attack_power)

