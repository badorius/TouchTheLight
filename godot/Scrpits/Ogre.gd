extends CharacterBody2D

@export var speed = 50.0
#var AttackCount = 3
const DISTANCE_THRESHOLD = 100  # Distancia mínima para separarte del jugador
const MAX_DISTANCE_ATACK = 115
const MIN_DISTANCE_ATACK = 100
const JUMP_VELOCITY = -350.0
var state_machine
@export var state : String = "Iddle"
var target_position : Vector2
@export var timer : float = 0
@export var live : int = 1000
@export var arrow_direction : int
@export var ArrowDamage_sound : AudioStreamPlayer2D
@export var StartAttack_sound : AudioStreamPlayer2D
@export var HitAttack_sound : AudioStreamPlayer2D
@onready var player : CharacterBody2D = get_node("../../Player")
@export var score_value : int = 100
@export var is_over_player : bool = false
@export var level_completed : bool = false
@export var Toxic : bool = false
var FreqToxic : float = 10.0
var FreqCounter : float = 0
const DamageIndicator = preload("../Objects/Efects/damage_indicator.tscn")
@onready var ProgressBar3 : TextureProgressBar = get_node("ProgressBar/Control/TextureProgressBar")
const Explode = preload("../Objects/Efects/EnemyExplode.tscn")
var startrun : bool = false
@onready var Camera : Camera2D = get_node("../../Camera2D")
 
const FlayingEye = preload("../Objects/Enemies/FlayingEye.tscn")
const Rock = preload("../Objects/WorldObjects/Rock.tscn")
const Skeleton = preload("../Objects/Enemies/skeleton.tscn")
const NightBorne = preload("../Objects/Enemies/NightBorne.tscn")
const IceArea = preload("../Objects/Efects/ice_area.tscn")
const FireArea = preload("../Objects/Efects/fire_area.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const TreasureChest = preload("../Objects/WorldObjects/TreasureChest.tscn")

func _ready():
	$Sprite2D.visible = true
	ArrowDamage_sound = $ArrowDamage
	StartAttack_sound = $StartAttack
	HitAttack_sound = $HitAttack
	state_machine = $AnimationTree.get('parameters/playback')
	#var player = get_parent().get_node("Player")


func _process(delta):
		if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD * 5 or state == "Hurt":
			startrun = true
			

func _physics_process(delta):
	ProgressBar3.value = live/10.0
	
	if startrun and state != "Death":
		if live <= 0:
			death()
			
		else:
			if Toxic == true:
				if FreqCounter < FreqToxic:
					FreqCounter += 0.1
				else:
					FreqCounter = 0
					hurt(5)
				
				
			if state != "Death":
				if state != "Attack":
					if abs(global_position.distance_to(player.global_position)) <= DISTANCE_THRESHOLD:
						set_scapeplayer()
					else:
						set_chaseplayer()
						
				if abs(global_position.distance_to(player.global_position)) <= MAX_DISTANCE_ATACK and abs(global_position.distance_to(player.global_position)) >= MIN_DISTANCE_ATACK:
					set_attack()

			
			# Add the gravity.
			if not is_on_floor():
				velocity.y += gravity * delta
			move_and_slide()
	
func set_iddle():
	state_machine.travel('Iddle')

func set_attack():
	#FIX ATTACK COULD MOVE PLAYER FROM SIDE TO SIDE IN ORDER TO MAKE FUNY
	velocity.x = 0
	state = "Attack"
	var direction = (player.global_position - global_position).normalized()
	#Animation Attack and SET POSITION AREA ATACK
	if direction.x > 0:
		arrow_direction = 1
		get_node( "Sprite2D" ).set_flip_h( false )
		$Sprite2D/Area2D.position.x = 0
		$ImpactEffect.position.x = 100
	else:
		arrow_direction = - 1
		get_node( "Sprite2D" ).set_flip_h( true )
		$Sprite2D/Area2D.position.x = -99
		$ImpactEffect.position.x = -100
	state_machine.travel('Attack')
	
func icerun():
	var main = get_tree().current_scene
	#ICE OBJECT
	#var A = IceArea.instantiate()
	#FIRE OBJECT
	var A = FireArea.instantiate()
	A.global_position = global_position
	if arrow_direction == 1:
		A.position.x = global_position.x + 30
	else:
		A.position.x = global_position.x - 90
	A.position.y = global_position.y + 50
	A.direction = arrow_direction
	main.add_child(A)
	print(arrow_direction)
	
func unset_attack():
	state = "no"

func set_chaseplayer():
	var direction = (player.global_position - global_position).normalized()
	if direction.x > 0:
		get_node( "Sprite2D" ).set_flip_h( false )
		state_machine.travel('Run')
		velocity.x = direction.x * speed
	else:
		get_node( "Sprite2D" ).set_flip_h( true )
		state_machine.travel('Run')	
		velocity.x = direction.x  * speed
		
		
func set_scapeplayer():
	speed = player.SPEED + 50
	var direction = (player.global_position - global_position).normalized()
	if direction.x > 0:
		get_node( "Sprite2D" ).set_flip_h( false )
		state_machine.travel('Run')
		velocity.x = -abs(direction.x) * speed
	else:
		get_node( "Sprite2D" ).set_flip_h( true )
		state_machine.travel('Run')	
		velocity.x = +abs(direction.x) * speed
	speed = 50
	
		
func hurt(damage):
	live -= damage
	ArrowDamage_sound.play()
	ProgressBar3.value = live
	state_machine.travel('Hurt')
	
	#FIX Random size
	var offset_position = randi() % 20
	var main = get_tree().current_scene
	var D = DamageIndicator.instantiate()
	var color = "yellow"
	D.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
	D.show_damage(damage, color)
	main.add_child(D)
	

func do_hurt():
	var attack_power = randi() % 100
	player.hurt(attack_power)
	

func drop_enemy():
	var main = get_tree().current_scene
	#Random enemy
	var EnemyRnd = randi() % 1
	
	var offset_position = randi() % 300
	var direction = (player.global_position - global_position).normalized()
	# Instatnce new enmies and Drop enemies
	
	match EnemyRnd:
		0:
			var EnemyDrop = Rock.instantiate()
			if direction.x > 1:
				EnemyDrop.global_position = Vector2(global_position.x  + offset_position , (global_position.y) - offset_position * 5)
			else:
				EnemyDrop.global_position = Vector2(global_position.x - 100  - offset_position , (global_position.y) - offset_position * 5)
			main.add_child(EnemyDrop)
		1:
			var EnemyDrop = Skeleton.instantiate()

			if direction.x > 1:
				EnemyDrop.global_position = Vector2(global_position.x*2  - offset_position , (global_position.y) - offset_position * 5)
			else:
				EnemyDrop.global_position = Vector2(global_position.x/2  - offset_position , (global_position.y) - offset_position * 5)
			main.add_child(EnemyDrop)
		2:
			var EnemyDrop = NightBorne.instantiate()
			if direction.x > 1:
				EnemyDrop.global_position = Vector2(global_position.x*2  - offset_position , (global_position.y) - offset_position * 5)
			else:
				EnemyDrop.global_position = Vector2(global_position.x/2  - offset_position , (global_position.y) - offset_position * 5)
			main.add_child(EnemyDrop)	
		3:
			var EnemyDrop = FlayingEye.instantiate()
			if direction.x > 1:
				EnemyDrop.global_position = Vector2(global_position.x*2  - offset_position , (global_position.y) - offset_position * 5)
			else:
				EnemyDrop.global_position = Vector2(global_position.x/2  - offset_position , (global_position.y) - offset_position * 5)
			main.add_child(EnemyDrop)



func drop_item():
		var direction = (player.global_position - global_position).normalized()
		var main = get_tree().current_scene
		var A = TreasureChest.instantiate()
		A.global_position = global_position
		if direction.x == 1:
			A.position.x = global_position.x + 15
		else:
			A.position.x = global_position.x - 45
		A.position.y = -450
		main.add_child(A)


func explode():
		var main = get_tree().current_scene
		var A = Explode.instantiate()
		A.global_position = global_position
		main.add_child(A)
		
func death():
	state = "Death"
	drop_item()
	$Sprite2D.visible = false
	velocity = Vector2(0, 0)
	state_machine.travel('Death')
	explode()
	player.add_score(score_value)
	level_completed = true
	#ADD ANIMATION TRESURE LIGHT AND NEXT LEVEL
	#get_tree().change_scene_to_file("res://Objects/Level2.tscn")


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		var attack_power = randi() % 100
		body.hurt(attack_power)
		Camera.shake_window()
		
func decrease_speed(value):
	speed -= value

func toxic():
	Toxic = true
