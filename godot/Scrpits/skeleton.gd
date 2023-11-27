extends Area2D

var speed = 100
@export var direction : int = -1
@export var live : int = 100
var walk_count_max = 90
var count = walk_count_max
@onready var progress_bar : TextureProgressBar = get_node("../CanvasLayer/TextureProgressBar")

func _process(delta):
	pass


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
	

func _on_body_entered(body):
		if body.is_in_group("Player"):
			body.game_over()
			
func hurt(damage):
		live -= damage
		$TextureProgressBar.value = live

		print($TextureProgressBar.value)
