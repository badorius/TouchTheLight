extends Area2D

@export var speed = randi() % 500 + 400
@export var direction : int = 1
@export var damage : int = 100
@export var state : String = "run"

@export var ThunderSound : AudioStreamPlayer2D
#Sounds


func _ready():
	ThunderSound = $thunder
	$"."
	$StormSprite.visible = false
	$AnimationPlayer.play("StormRun")
	ThunderSound.play()
	
func _physics_process(delta):
	#if state == "run":
	#	position += transform.y * speed * delta
	#else:
	#	$AnimationPlayer.play("FireExplode")
	pass
		

func explode():
	pass



func _on_body_entered(body):
	state = "stop"
	ThunderSound.play()
	if body.is_in_group("enemies"):
		body.live -= 1
		if body.live <= 0:
			body.death()
		else:
			body.hurt(damage)
	

