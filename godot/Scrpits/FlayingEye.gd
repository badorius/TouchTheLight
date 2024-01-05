extends CharacterBody2D

const SPEED = 200.0
var AttackCount = 3
const DISTANCE_THRESHOLD = 100  # Distancia mínima para perseguir al jugador
const DISTANCE_ATACK = 40
const JUMP_VELOCITY = -350.0
var state_machine
@export var state : String = "Iddle"
var target_position : Vector2
@export var timer : float = 0
@export var live : int = 200
@export var ArrowDamage_sound : AudioStreamPlayer2D
@onready var player : CharacterBody2D = get_node("../Player")
@export var score_value : int = 50
@export var attack_power = randi() % 30
const DamageIndicator = preload("../Objects/damage_indicator.tscn")
var startrun : bool = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	ArrowDamage_sound = $ArrowDamage
	state_machine = $AnimationTree.get('parameters/playback')
	#var player = get_parent().get_node("Player")

func _process(delta):
		if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD * 5 or state == "Hurt":
			startrun = true
			
func _physics_process(delta):
	if startrun:
		$ProgressBar.value = live
		ArrowDamage_sound = $ArrowDamage
		if live <= 0:
			death()
			state = "Death"
			timer = 0
			
		timer += delta	
		if timer > 3.0:
			var random_choice = randi() % 3
			match random_choice:
				0:
					state = "WalkingLeft"
					timer = 0
				1:
					state = "WalkingRight"
				2:
					state = "Iddle"
					timer = 0

		match state:
			"Iddle":
				set_iddle()
			"WalkingLeft":
				set_walkingleft()
			"WalkingRight":
				set_walkingright()
			"ChasePlayer":
				set_chaseplayer()
			"Attack":
				set_attack()

		#CHECK DISTANCE TO CHESE OR ATACK
		if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD or state == "Hurt":
			state = "ChasePlayer"
			if global_position.distance_to(player.global_position) < DISTANCE_ATACK:
				state = "Attack"
		if state == "ChasePlayer":
				$PointLight2D.enabled = true
		else:
				$PointLight2D.enabled = false

	move_and_slide()
	
				
func set_iddle():
	state_machine.travel('Iddle')

func set_attack():
	var direction = (player.global_position - global_position).normalized()
	if direction.x > 0:
		get_node( "Sprite2D" ).set_flip_h( false )
	else:
		get_node( "Sprite2D" ).set_flip_h( true )
	#state_machine.travel('Attack')
	if global_position.distance_to(player.global_position) > DISTANCE_THRESHOLD:
		set_iddle()

		
func set_chaseplayer():
	var direction = (player.global_position - global_position).normalized()
	if direction.x > 0:
		get_node( "Sprite2D" ).set_flip_h( false )
		state_machine.travel('Run')
		velocity = direction * SPEED
	else:
		get_node( "Sprite2D" ).set_flip_h( true )
		state_machine.travel('Run')	
		velocity = direction  * SPEED

		
func set_walkingright():
	target_position = global_position + Vector2(randf_range(50, 150), 0)
	velocity.x = SPEED
	get_node( "Sprite2D" ).set_flip_h( false )
	state_machine.travel('Run')	

	
	if global_position.x > target_position.x or timer > 3.0:
		set_iddle()
		
func set_walkingleft():
	target_position = global_position + Vector2(randf_range(-50, -150), 0)
	velocity.x = -SPEED
	get_node( "Sprite2D" ).set_flip_h( true )
	state_machine.travel('Run')	

	
	if global_position.x < target_position.x or timer > 3.0:
		set_iddle()
			
func hurt(damage):
	if live <= 0:
		death()
	else:
		ArrowDamage_sound.play()
		#state_machine.travel('Hurt')
		live -= damage
		$ProgressBar.value = live
		state = "Hurt"
		
		#FIX Random size
		var offset_position = randi() % 20
		var main = get_tree().current_scene
		var D = DamageIndicator.instantiate()
		var color = "yellow"
		D.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
		D.show_damage(damage, color)
		main.add_child(D)


func do_hurt():
	attack_power = randi() % 30
	player.hurt(attack_power)

		
func explode():
	pass
		
func death():
	queue_free()
	#state_machine.travel('Death')
	player.add_score(score_value)


