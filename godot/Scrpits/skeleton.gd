extends CharacterBody2D

var speed = 100
@export var direction : int = -1
@export var live : int = 100
var walk_count_max = 90
var count = walk_count_max
var state_machine
@export var timer : float = 0
@export var ArrowDamage_sound : AudioStreamPlayer2D
const DamageIndicator = preload("../Objects/damage_indicator.tscn")
@export var attack_power = randi() % 10
@export var state = "Iddle"

func _ready():
	ArrowDamage_sound = $ArrowDamage
	state_machine = $AnimationTree.get('parameters/playback')
	changeSprite2D(state)
	$ProgressBar.value = live
	if live <= 0:
		death()
		state = "Death"
		timer = 0
	
			
func _process(delta):
	$ProgressBar.value = live


func _physics_process(delta):
	timer += delta	
	if timer > 1.0:
		var random_choice = randi() % 2
		match random_choice:
			0:
				state = "Walk"
				timer = 0

			1:
				state = "Iddle"
				timer = 0

	match state:
		"Walk":	
			walk(delta)
		"Death":
			death()
		"Shield":
			$Shield.visible = true
		"Hit":
			pass
		"Iddle":
			set_iddle()
		

func walk(delta):
	flip_sprite_direction(direction)
	if direction == 1:
		count += 1 
		position += transform.x * speed * delta
	if direction == -1:
		count -= 1
		position -= transform.x * speed * delta
	
	if count == 1:
		direction = 1
	if count == walk_count_max:
		direction = -1
	state = "Walk"
	changeSprite2D(state)
	state_machine.travel('Walk')	
	
	
func set_iddle():
	flip_sprite_direction(direction)
	state = "Iddle"
	changeSprite2D(state)
	state_machine.travel('Iddle')

func punch_shield():
	state = "Shield"
	flip_sprite_direction(direction)
	changeSprite2D(state)
	state_machine.travel('Shield')
			
func hurt(damage):
		if live <= 0:
			death()
		
		else:
			state = "Hit"
			changeSprite2D(state)
			flip_sprite_direction(direction)
			state_machine.travel('Hit')	
			ArrowDamage_sound.play()
			live -= damage
			$ProgressBar.value = live
			
			#FIX Random size
			var offset_position = randi() % 20
			var main = get_tree().current_scene
			var D = DamageIndicator.instantiate()
			var color = "yellow"
			D.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
			D.show_damage(damage, color)
			main.add_child(D)
		

			
			
func changeSprite2D(state):
	
	$Walk.visible = false
	$Death.visible = false
	$Shield.visible = false
	$Hit.visible = false
	$Iddle.visible = false
	
	match state:
		"Walk":	
			$Walk.visible = true
		"Death":
			$Death.visible = true
		"Shield":
			$Shield.visible = true
		"Hit":
			$Hit.visible = true
		"Iddle":
			$Iddle.visible = true
		
func explode():
	pass
	
func death():
	state = "Death"
	changeSprite2D(state)
	state_machine.travel('Death')
	
	
func flip_sprite_direction(direction):
	if direction == 1:
		get_node( "Walk" ).set_flip_h( false )
		get_node( "Death" ).set_flip_h( false )
		get_node( "Shield" ).set_flip_h( false )
		get_node( "Hit" ).set_flip_h( false )
		get_node( "Iddle" ).set_flip_h( false )
	if direction == -1:
		get_node( "Walk" ).set_flip_h( true )
		get_node( "Death" ).set_flip_h( true )
		get_node( "Shield" ).set_flip_h( true )
		get_node( "Hit" ).set_flip_h( true )
		get_node( "Iddle" ).set_flip_h( true )


func _on_area_2d_body_entered(body):
	attack_power = randi() % 10
	if body.is_in_group("Player"):
		state = "Shield"
		punch_shield()
		body.hurt(attack_power)
