extends Area2D

var speed = 100
@export var direction : int = -1
var walk_count_max = 90
var count = walk_count_max


func _physics_process(delta):

	if direction == 1:
		count += 1 
		position += transform.x * speed * delta
		get_node( "Walk" ).set_flip_h( false )
	if direction == -1:
		count -= 1
		position -= transform.x * speed * delta
		get_node( "Walk" ).set_flip_h( true )
	
	if count == 1:
		direction = 1
	if count == walk_count_max:
		direction = -1
		
	$AnimationPlayer.play("Walk")
