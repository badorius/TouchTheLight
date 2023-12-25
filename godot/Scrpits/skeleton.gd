extends CharacterBody2D

var speed = 100
@export var direction : int = -1
@export var live : int = 100
var walk_count_max = 90
var count = walk_count_max
var state_machine
@export var ArrowDamage_sound : AudioStreamPlayer2D
const DamageIndicator = preload("../Objects/damage_indicator.tscn")
@export var attack_power = randi() % 10

func _ready():
	ArrowDamage_sound = $ArrowDamage
	state_machine = $AnimationTree.get('parameters/playback')

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
		
	state_machine.travel('Walk')	

	
func _on_body_entered(body):
		attack_power = randi() % 10
		if body.is_in_group("Player"):
			body.hurt(attack_power)

			
func hurt(damage):
		state_machine.travel('Hit')	
		ArrowDamage_sound.play()
		live -= damage
		$ProgressBar.value = live
		
		#FIX Random size
		var offset_position = randi() % 20
		var main = get_tree().current_scene
		var D = DamageIndicator.instantiate()
		var color = "yellow"
		D.global_position = Vector2(global_position.x - offset_position, (global_position.y/10) - offset_position)
		D.show_damage(damage, color)
		main.add_child(D)
		
		if live <= 0:
			death()
			
		
func explode():
	pass
	
func death():
	state_machine.travel('Death')	
	
	

