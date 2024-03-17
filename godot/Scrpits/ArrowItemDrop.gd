extends Area2D
var LightCatch : AudioStreamPlayer2D
var maxup = 10
var maxdown = 10


#Vars to Wave y movement
var bob_height : float = 3.0
var bob_speed : float = 8.0
@onready var start_y : float = global_position.y
var t : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	#SONIDOS
	LightCatch = $LightCatch


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		# increase 't' over time.
		t += delta
		
		# creloopate a sin wave that bobs up and down.
		var d = (sin(t * bob_speed) + 1) / 2
		
		# apply that to  Y position.
		global_position.y = start_y + (d * bob_height)



func _on_body_entered(body):
	if body.is_in_group("Player"):
		LightCatch.play()
		body.update_arrows(10, 0)
		queue_free()

		
		
