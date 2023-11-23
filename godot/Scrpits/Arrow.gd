extends Area2D

var speed = 750
@export var direction : int = 1

func _physics_process(delta):

	if direction == 1:
		position += transform.x * speed * delta
		get_node( "Arrow" ).set_flip_h( false )
	if direction == -1:
		position -= transform.x * speed * delta
		get_node( "Arrow" ).set_flip_h( true )

func _on_Arrow_body_entered(body):
	if body.is_in_group("arrow"):
		body.queue_free()
	queue_free()
