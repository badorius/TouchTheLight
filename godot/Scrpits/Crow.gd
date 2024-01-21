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
@export var live : int = 50
@export var ArrowDamage_sound : AudioStreamPlayer2D
@onready var player : CharacterBody2D = get_node("../../Player")
@export var score_value : int = 50
@export var attack_power = randi() % 30
const DamageIndicator = preload("../Objects/damage_indicator.tscn")
@export var Toxic : bool = false
var FreqToxic : float = 10.0
var FreqCounter : float = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ProgressBar3 : TextureProgressBar = get_node("ProgressBar/Control/TextureProgressBar") 
@onready var Explode : AnimationPlayer = get_node("EnemyExplode/AnimationPlayer")

func _ready():
	ArrowDamage_sound = $ArrowDamage
	state_machine = $AnimationTree.get('parameters/playback')
	#var player = get_parent().get_node("Player")
	$EnemyExplode.visible = false
	set_iddle()
	
func _process(delta):
	pass
			
func _physics_process(delta):
	if Toxic == true:
		if FreqCounter < FreqToxic:
			FreqCounter += 0.1
		else:
			FreqCounter = 0
			hurt(5)
	
	ProgressBar3.value = live
	ArrowDamage_sound = $ArrowDamage
	if live <= 0:
		death()
		state = "Death"


		#CHECK DISTANCE TO CHESE OR ATACK
	if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD or state == "Hurt":
		set_startfly()


	move_and_slide()
	
				
func set_iddle():
	state_machine.travel('Iddle')
	velocity = global_position 
	
func set_startfly():
	var direction = (player.global_position - global_position).normalized()
	if direction.x > 0:
		get_node( "Sprite2D" ).set_flip_h( true )
		state_machine.travel('StartFly')
	else:
		get_node( "Sprite2D" ).set_flip_h( false )
		state_machine.travel('StartFly')
	velocity = global_position
		
func set_chaseplayer():
	var direction = (player.global_position - global_position).normalized()
	if direction.x > 0:
		get_node( "Sprite2D" ).set_flip_h( true )
		state_machine.travel('Run')
		velocity = direction * speed
	else:
		get_node( "Sprite2D" ).set_flip_h( false )
		state_machine.travel('Run')	
		velocity = direction  * speed

func hurt(damage):
	if live <= 0:
		death()
	else:
		ArrowDamage_sound.play()
		#state_machine.travel('Hurt')
		live -= damage
		ProgressBar3.value = live
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
	Explode.play("Explode")
		
func death():
	state_machine.travel('Death')
	explode()

func decrease_speed(value):
	speed -= value

func toxic():
	Toxic = true
