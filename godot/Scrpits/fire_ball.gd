extends Area2D

@export var speed = randi() % 500 + 400
@export var direction : int = 1
@export var damage : int = 10
@export var state : String = "run"

@export var ThunderSound : AudioStreamPlayer2D
#Sounds


func _ready():
	ThunderSound = $thunder
	$"."
	$FireSprite.visible = false
	$FireBall.visible = true
	$AnimationPlayer.play("FireRun")
	
	
func _physics_process(delta):
	if state == "run":
		position += transform.y * speed * delta
	else:
		$AnimationPlayer.play("FireExplode")
		

func explode():
	pass



func _on_body_entered(body):
	state = "stop"
	ThunderSound.play()
	if body.is_in_group("Player"):
		body.live -= 1
		if body.live <= 0:
			$AnimationPlayer.play("FireExplode")
			body.death()
		else:
			$AnimationPlayer.play("FireExplode")
			body.hurt(damage)
		
	else:
		$AnimationPlayer.play("FireExplode")
		

