extends RigidBody2D

@export var ThunderSound : AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	ThunderSound = $thunder
	#ThunderSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	apply_force(Vector2(100,100))
	#apply_central_force(Vector2(100,100))





func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		var attack_power = randi() % 100
		#body.hurt(attack_power)
