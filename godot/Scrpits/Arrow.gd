extends Area2D

var speed = 750
@export var direction : int = 1

func _physics_process(delta):

	if direction == 1:
		position += transform.x * speed * delta
	if direction == -1:
		position -= transform.x * speed * delta

func _on_Arrow_body_entered(body):
	if body.is_in_group("arrow"):
		body.queue_free()
	queue_free()
