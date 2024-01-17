extends Area2D

@export var speed = 200
@export var direction : int = 1
@export var damage : int = 10
@export var state : String = "run"


#Sounds


func _ready():
	$"."
	#$RetroImpactEffectPack3C.visible = false
	state = "run"
	if direction == 1:
		get_node( "FireSprite" ).set_flip_h( false )
	if direction == -1:
		get_node( "FireSprite" ).set_flip_h( true )
		
	$AnimationPlayer.play("FireRun")
func _physics_process(delta):
	if state == "run":
		if direction == 1:
			position += transform.x * speed * delta
			get_node( "FireSprite" ).set_flip_h( false )
		if direction == -1:
			position -= transform.x * speed * delta
			get_node( "FireSprite" ).set_flip_h( true )


func explode():
	pass



func _on_body_entered(body):

	if body.is_in_group("Player"):
		body.live -= 1
		if body.live <= 0:
			$AnimationPlayer.play("FireExplode")
		else:
			$AnimationPlayer.play("FireExplode")
			body.hurt(damage)
		

