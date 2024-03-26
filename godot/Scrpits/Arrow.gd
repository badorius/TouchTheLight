extends Area2D

@export var speed = 750
@export var direction : int = 1
@export var damage : int = 100
@export var state : String = "run"
var state_machine
const MaxDist : int = 350
#Sounds


func _ready():
	$Arrow.visible = true
	#$RetroImpactEffectPack3C.visible = false
	state = "run"
	state_machine = $AnimationTree.get('parameters/playback')

	if direction == 1:
		get_node( "RetroImpactEffectPack3C" ).set_flip_h( false )
	if direction == -1:
		get_node( "RetroImpactEffectPack3C" ).set_flip_h( true )
	state_machine.travel('Arrow_Fire')
	
func _physics_process(delta):
	if state == "run":
		if direction == 1:
			position += transform.x * speed * delta
			get_node( "Arrow" ).set_flip_h( false )
		if direction == -1:
			position -= transform.x * speed * delta
			get_node( "Arrow" ).set_flip_h( true )
			
		print (abs(position.x))
		if abs(position.x) > MaxDist:
			explode()
		


func explode():
	state_machine.travel('Arrow_Explode')


func _on_area_entered(area):
	pass
	"""
	state = "collided"
	#FIX ##### Neds to wait before queue_free
	#state_machine.travel('Arrow_Explode')
	#queue_free()

	if area.is_in_group("enemies"):

		state_machine.travel('Arrow_Explode')
		area.live -= 1
		if area.live <= 0:
			area.death()
			queue_free()
		else:
			area.hurt(damage)
			queue_free()
	else:
		state_machine.travel('Arrow_Explode')
	"""
			

func _on_body_entered(body):
	state = "collided"
	state_machine.travel('Arrow_Explode')
	if body.is_in_group("enemies"):
		body.live -= 1
		if body.live <= 0:
			state_machine.travel('Arrow_Explode')
			body.death()
			#body.queue_free()
			#queue_free()
		else:
			state_machine.travel('Arrow_Explode')
			#queue_free()
			body.hurt(damage)
	else:
		state_machine.travel('Arrow_Explode')
		

