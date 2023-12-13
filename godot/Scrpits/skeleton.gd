extends Area2D

var speed = 100
@export var direction : int = -1
@export var live : int = 100
var walk_count_max = 90
var count = walk_count_max
@export var ArrowDamage_sound : AudioStreamPlayer2D

func _ready():
	ArrowDamage_sound = $ArrowDamage

func _process(delta):
	$ProgressBar.value = live

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
			if body.attacking == true:
				hurt(100)
			body.hurt(5)
			
func hurt(damage):
		ArrowDamage_sound.play()
		live -= damage
		$ProgressBar.value = live
		if live <= 0:
			death()
		
func explode():
	pass
	
func death():
	queue_free()
	

