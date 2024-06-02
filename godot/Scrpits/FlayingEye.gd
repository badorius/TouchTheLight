extends CharacterBody2D

@export var speed = 200.0
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
@onready var player : CharacterBody2D = get_node("../../Player")
@export var score_value : int = 50
@export var attack_power = randi() % 30
const DamageIndicator = preload("../Objects/Efects/damage_indicator.tscn")
const PointsIndicator = preload("res://Objects/Efects/points_indicator.tscn")
@export var pointsvalue : int = 300
var startrun : bool = false
@export var Toxic : bool = false
var FreqToxic : float = 10.0
var FreqCounter : float = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ProgressBar3 : TextureProgressBar = get_node("ProgressBar/Control/TextureProgressBar") 
const Explode = preload("../Objects/Efects/EnemyExplode.tscn")

func _ready():
	ArrowDamage_sound = $ArrowDamage
	state_machine = $AnimationTree.get('parameters/playback')
	
	$Area2D/CollisionShape2D2.disabled = false
	$CollisionShape2D.disabled = false
	#var player = get_parent().get_node("Player")

	
func _process(delta):
		if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD * 5 or state == "Hurt":
			startrun = true
			
func _physics_process(delta):
	
	if Toxic == true:
		if FreqCounter < FreqToxic:
			FreqCounter += 0.1
		else:
			FreqCounter = 0
			hurt(5)
	
	if startrun and state != "Death":
		ProgressBar3.value = live
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
		velocity = direction * speed
	else:
		get_node( "Sprite2D" ).set_flip_h( true )
		state_machine.travel('Run')	
		velocity = direction  * speed

		
func set_walkingright():
	target_position = global_position + Vector2(randf_range(50, 150), 0)
	velocity.x = speed
	get_node( "Sprite2D" ).set_flip_h( false )
	state_machine.travel('Run')	

	
	if global_position.x > target_position.x or timer > 3.0:
		set_iddle()
		
func set_walkingleft():
	target_position = global_position + Vector2(randf_range(-50, -150), 0)
	velocity.x = -speed
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
		ProgressBar3.value = live
		state = "Hurt"



func do_hurt():
	attack_power = randi() % 30
	player.hurt(attack_power)

		
func explode():
		var main = get_tree().current_scene
		var A = Explode.instantiate()
		A.global_position = global_position
		main.add_child(A)
		
func death():
	#FIX Random size
	var offset_position = randi() % 20
	var main = get_tree().current_scene
	var D = PointsIndicator.instantiate()
	var color = "white"
	D.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
	D.show_points(pointsvalue, color)
	main.add_child(D)
	player.add_score(pointsvalue)
	
	state = "Death"
	velocity = Vector2(0, 0)
	state_machine.travel('Death')
	explode()

func decrease_speed(value):
	speed -= value

func toxic():
	Toxic = true

func _on_area_2d_body_entered(body):
	var attack_power = randi() % 100
	if body.is_in_group("Player"):
		body.hurt(attack_power)
		live = 0

