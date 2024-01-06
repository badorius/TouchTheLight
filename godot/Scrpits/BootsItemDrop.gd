extends Area2D
var LightCatch : AudioStreamPlayer2D
var maxup = 10
var maxdown = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	#SONIDOS
	LightCatch = $LightCatch


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	if body.is_in_group("Player"):
		LightCatch.play()
		body.update_boots(10)
		queue_free()

		
		
