extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -350.0
@export var live : int = 100
var state_machine
@export var attack_power : int  = 10
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Socre vars
@export var score : int = 0
@export var lives : int = 5
@onready var score_text : Label = get_node("../CanvasLayer/ScoreText")
@onready var progress_bar : ProgressBar = get_node("../CanvasLayer/ProgressBar")
@onready var progress_bar_light : ProgressBar = get_node("../CanvasLayer/ProgressBarLight")
@onready var lives_text : Label = get_node("../CanvasLayer/Lives")

#Load Arrow tscn
const Arrow = preload("../Objects/Arrow.tscn")
var arrow_direction : int = 1

#DEFAULT STATE START IDLE
var state : String = "Idle"

# Light vaule default
var base_light : Vector2 = Vector2(0.5, 0.5)
@export var decrease_value : Vector2 = Vector2(0.001, 0.001)
@export var max_light : Vector2 = Vector2(2.0, 2.0)
# Referencia al PointLight2D
@export var player_light : PointLight2D

#Sounds
var jump_sound : AudioStreamPlayer2D
var arrow_sound : AudioStreamPlayer2D 
var dash_sound : AudioStreamPlayer2D
var hurt_sound : AudioStreamPlayer2D



func _ready():
	
	state_machine = $AnimationTree.get('parameters/playback')
	state_machine.travel('Idle')
	$ProgressBar.value = live
	progress_bar.value = live
	# Utiliza get_node para acceder al nodo "Warrior" y luego al nodo "PointLight2D" dentro de él
	player_light = $Warrior/PointLight2D
	# Establecer la escala de la luz al valor base al iniciar
	player_light.scale = base_light
	progress_bar_light.value = 0

	
	#SONIDOS
	jump_sound = $Jump
	arrow_sound = $arrow
	dash_sound = $dash
	hurt_sound = $Hurt
func _physics_process(delta):
	
	var direction = Input.get_axis("ui_left", "ui_right")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if not state == 'Atack1':
			state = "Jump"
	else:
		state = "Idle"
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY
		state = "Jump"
		
	# Fire BOW
	if progress_bar_light.value > 0:
		if Input.is_action_pressed("ui_fire1") and not Input.is_action_just_released("ui_fire1"):
			#velocity.x = move_toward(velocity.x, 0, SPEED)
			state = "BowShooting"
		if Input.is_action_just_released("ui_fire1"):
				arrow_sound.play()
				decrease_light_scale(Vector2(decrease_value)*10)
				shoot(arrow_direction)
				state = "Idle"
			
	# Sword Atack
	if Input.is_action_pressed("ui_fire2") and not Input.is_action_just_released("ui_fire2"):
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		state = "Atack1"
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_released("ui_fire2"):
			arrow_sound.play()
			#shoot(arrow_direction)
			state = "Idle"

	# Get the input direction and handle the movement/deceleration.
	if direction:
		if direction == -1:
			get_node( "Warrior" ).set_flip_h( false )
			arrow_direction = direction
			velocity.x = direction * SPEED
		if direction == 1:
			velocity.x = direction * SPEED
			get_node( "Warrior" ).set_flip_h( true )
			arrow_direction = direction
			
		#SET STATE ON MOVEMENT
		if not is_on_floor():
			state = "Jump"
		elif Input.is_action_pressed("ui_down"):
			state = "SlideDown"
			if Input.is_action_just_pressed("ui_down"):
				dash_sound.play()
		else:
			state = "WalkRight"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#ANIMATION
	state_machine.travel(state)
	move_and_slide()
	
	#Decrease light
	decrease_light_scale(Vector2(decrease_value))
	
	#QUIT GAME
	if Input.is_action_just_pressed("ui_cancel") and is_on_floor():
		game_quit()
	
	#PLAYER DOWN GAMEOVER
	if global_position.y > 250:
		game_over()

#GAMEOVER FUNCTION
func game_over ():
	#PENDING FIX FUNCTIoN NAME (NOT GAMEOVER) DIE LIVES
	update_lives(1)
	get_tree().reload_current_scene()

#QUIT GAME FUNCTION
func game_quit ():
	get_tree().quit(0)
	
#ADD SCORE FUNCTION
func add_score (amount):
	score += amount
	score_text.text = str("Score: ", score)
	
#UPDATE LIVES FUNCTION
func update_lives (amount):
	lives -= amount
	print(lives)
	lives_text.text = str("Lives: ", lives)
	
	
#SHOOT ARROW FUNCTION
func shoot(arrow_direction):
	var main = get_tree().current_scene
	var A = Arrow.instantiate()
	A.global_position = global_position
	A.position.x = global_position.x + 35
	A.position.y = global_position.y + 15
	A.direction = arrow_direction
	main.add_child(A)
	
# Función para incrementar la escala de la luz
func increment_light_scale(increment_amount: Vector2):
	if player_light.scale < max_light:
		player_light.scale += increment_amount
	if progress_bar_light.value < 10000:
		progress_bar_light.value += increment_amount.x * 10000
		

func decrease_light_scale(decrease_amount: Vector2):
	if player_light.scale >= base_light:
		player_light.scale -= decrease_amount
	else:
		progress_bar_light.value = 0
	#if progress_bar_light.value >= 1:
		#progress_bar_light.value -= decrease_amount.x * 100
		
func do_hurt():
	pass
	#player.hurt(attack_power)

func hurt(damage):
		live -= damage
		hurt_sound.play()
		$ProgressBar.value = live
		progress_bar.value = live
		state = "Hurt"
		state_machine.travel("Hurt")

		if live <= 0:
			game_over()
		
func explode():
	pass


