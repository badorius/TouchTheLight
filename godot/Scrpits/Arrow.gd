extends Area2D

var speed = 750
@export var direction : int = 1
@export var damage : int = 10

#Sounds


func _ready():
	$AnimationImpact.play("Arrow_Fire")

func _physics_process(delta):
	if direction == 1:
		position += transform.x * speed * delta
		get_node( "Arrow" ).set_flip_h( false )
	if direction == -1:
		position -= transform.x * speed * delta
		get_node( "Arrow" ).set_flip_h( true )



func _on_area_entered(area):
	#FIX ##### Neds to wait before queue_free
	$AnimationImpact.play("Arrow_Explode")
	if area.is_in_group("enemies"):
		$AnimationImpact.play("Arrow_Explode")
		area.live -= 1
		if area.live <= 0:
			area.queue_free()
			#area.explode()
			queue_free()
		else:
			queue_free()
			area.hurt(damage)
			
func explode():
	pass
			
		
