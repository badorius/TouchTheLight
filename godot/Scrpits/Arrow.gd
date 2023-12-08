extends Area2D

var speed = 750
@export var direction : int = 1
@export var damage : int = 10

#Sounds


func _ready():
	$AnimationImpact.play("Arrow_Fire")
	if direction == 1:
		get_node( "RetroImpactEffectPack3C" ).set_flip_h( false )
	if direction == -1:
		get_node( "RetroImpactEffectPack3C" ).set_flip_h( true )

func _physics_process(delta):
	if direction == 1:
		position += transform.x * speed * delta
		get_node( "Arrow" ).set_flip_h( false )
	if direction == -1:
		position -= transform.x * speed * delta
		get_node( "Arrow" ).set_flip_h( true )


func explode():
	pass


func _on_area_entered(area):
	#FIX ##### Neds to wait before queue_free
	$AnimationImpact.play("Arrow_Explode")
	if area.is_in_group("enemies"):
		$AnimationImpact.play("Arrow_Explode")
		area.live -= 1
		if area.live <= 0:
			area.queue_free()
			area.death()
			queue_free()
		else:
			queue_free()
			area.hurt(damage)
			

func _on_body_entered(body):
	#FIX ##### Neds to wait before queue_free
	$AnimationImpact.play("Arrow_Explode")
	if body.is_in_group("enemies"):
		$AnimationImpact.play("Arrow_Explode")
		body.live -= 1
		if body.live <= 0:
			body.queue_free()
			body.death()
			queue_free()
		else:
			queue_free()
			body.hurt(damage)
	


