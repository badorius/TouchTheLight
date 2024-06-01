extends CharacterBody2D

@export var speed = 100
@export var direction : int = -1
@export var live : int = 100
@export var pointsvalue : int = 100
var walk_count_max = 90
var count = walk_count_max
var state_machine
@export var timer : float = 0
@export var ArrowDamage_sound : AudioStreamPlayer2D
@onready var player : CharacterBody2D = get_node("../../Player")
const DamageIndicator = preload("res://Objects/Efects/damage_indicator.tscn")
const PointsIndicator = preload("res://Objects/Efects/points_indicator.tscn")
@export var state = "Iddle"
@export var score_value : int = 10
@export var Toxic : bool = false
var FreqToxic : float = 10.0
var FreqCounter : float = 0
@onready var ProgressBar3 : TextureProgressBar = get_node("ProgressBar/Control/TextureProgressBar") 
#@onready var Explode : AnimationPlayer = get_node("EnemyExplode/AnimationPlayer")

const BootsItemDrop = preload("../Objects/Items/BootsItemDrop.tscn")
const ArrowItemDrop = preload("../Objects/Items/ArrowItemDrop.tscn")
const CoatItemDrop = preload("../Objects/Items/CoatItemDrop.tscn")
const LivePotionDrop = preload("../Objects/Items/LivePotionDrop.tscn")
const ManaPotionDrop = preload("../Objects/Items/ManaPotionDrop.tscn")
const Magic1ItemDrop = preload("../Objects/Items/Magic1ItemDrop.tscn")
const Magic2ItemDrop = preload("../Objects/Items/Magic2ItemDrop.tscn")
const Magic3ItemDrop = preload("../Objects/Items/Magic3ItemDrop.tscn")
const Explode = preload("../Objects/Efects/EnemyExplode.tscn")



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	ArrowDamage_sound = $ArrowDamage
	state_machine = $AnimationTree.get('parameters/playback')
	changeSprite2D(state)
	ProgressBar3.value = live
	
			
func _process(delta):
	ProgressBar3.value = live


func _physics_process(delta):
	if live <= 0 and state != "Death":
		death()
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Toxic == true:
		if FreqCounter < FreqToxic:
			FreqCounter += 0.1
		else:
			FreqCounter = 0
			hurt(5)
		
	if state != "Death":
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
		#"Death":
		#	death()
		"Shield":
			$Shield.visible = true
		"Hit":
			pass
		"Iddle":
			set_iddle()
		
	move_and_slide()

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
		if live <= 0 and state != "Death":
			death()
		
		else:
			state = "Hit"
			changeSprite2D(state)
			flip_sprite_direction(direction)
			state_machine.travel('Hit')	
			ArrowDamage_sound.play()
			live -= damage
			ProgressBar3.value = live
			
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
		var main = get_tree().current_scene
		var A = Explode.instantiate()
		A.global_position = global_position
		main.add_child(A)
	
func death():
	#FIX Random size
	var offset_position = randi() % 20
	var main = get_tree().current_scene
	var D = PointsIndicator.instantiate()
	var color = "yellow"
	D.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
	D.show_points(pointsvalue, color)
	
	main.add_child(D)
	state = "Death"
	drop_item()
	changeSprite2D(state)
	state_machine.travel('Death')
	explode()
	player.add_score(score_value)

	
	
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
	var attack_power = randi() % 100
	if body.is_in_group("Player"):
		state = "Shield"
		punch_shield()
		body.hurt(attack_power)
		
func decrease_speed(value):
	speed -= value
	
func toxic():
	Toxic = true

func drop_item():
		var main = get_tree().current_scene
		var rnd = randi() % 8
		match rnd:
			0:
				var A = BootsItemDrop.instantiate()
				A.global_position = global_position
				if direction == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y
				main.add_child(A)
			1:
				var A = ArrowItemDrop.instantiate()
				A.global_position = global_position
				if direction == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y
				main.add_child(A)
			2:
				var A = CoatItemDrop.instantiate()
				A.global_position = global_position
				if direction == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y
				main.add_child(A)
			3:
				var A = LivePotionDrop.instantiate()
				A.global_position = global_position
				if direction == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y
				main.add_child(A)
				
			4:
				var A = ManaPotionDrop.instantiate()
				A.global_position = global_position
				if direction == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y
				main.add_child(A)
				
			5:
				var A = Magic1ItemDrop.instantiate()
				A.global_position = global_position
				if direction == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y
				main.add_child(A)
			6:
				var A = Magic2ItemDrop.instantiate()
				A.global_position = global_position
				if direction == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y
				main.add_child(A)
			7:
				var A = Magic3ItemDrop.instantiate()
				A.global_position = global_position
				if direction == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y
				main.add_child(A)

