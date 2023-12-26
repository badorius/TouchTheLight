extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -350.0
@export var push_force = 80.0

@export var live : int = 100
var state_machine
@export var state : String = "Idle"
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
const DamageIndicator = preload("../Objects/damage_indicator.tscn")
@export var arrow_direction : int = 1

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
var sword_sound : AudioStreamPlayer2D



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
	sword_sound = $sword
	
func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	# Get the input direction and handle the movement/deceleration and orientation.
	if direction:
		arrow_direction = direction
		
	if direction and state != "Hurt":
		state = "WalkRight"
		walk(direction)
		if direction == -1:
			get_node( "Warrior" ).set_flip_h( false )
			$Warrior/Area2D.position.x = -34
		if direction == 1:
			get_node( "Warrior" ).set_flip_h( true )
			$Warrior/Area2D.position.x = 0
			
		# Slide Down
		if Input.is_action_pressed("ui_down"):
			slide(direction)
		else:
			walk(direction)
			
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if state != "Hurt":
			state = "Idle"
			iddle()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		state = "Jump"
		state_machine.travel('Jump')
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		state = "Jump"
		jump()

	# Fire BOW
	if Input.is_action_just_pressed("ui_fire1"):
		state = "BowShooting"
		bowing(arrow_direction)
			
	# Sword Atack
	if Input.is_action_just_pressed("ui_fire2"):
		state = "Atack1"
		atack1()

	move_and_slide()
	
	#
	# after calling move_and_slide()

	
	#Decrease light
	decrease_light_scale(Vector2(decrease_value))
	
	#QUIT GAME
	if Input.is_action_just_pressed("ui_cancel") and is_on_floor():
		game_quit()
	
	#PLAYER DOWN GAMEOVER
	if global_position.y > 250:
		game_over()


func walk(direction):
		velocity.x = direction * SPEED
		state_machine.travel('WalkRight')
		
#Func slide
func slide(direction):
	velocity.x = direction * SPEED
	state_machine.travel('SlideDown')
	dash_sound.play()



#FUNC BOWING
func bowing(arrow_direction):
	state_machine.travel('BowShooting')
	if progress_bar_light.value > 0:
		arrow_sound.play()
		decrease_light_scale(Vector2(decrease_value)*10)
		var main = get_tree().current_scene
		var A = Arrow.instantiate()
		A.global_position = global_position
		A.position.x = global_position.x + 35
		A.position.y = global_position.y + 15
		A.direction = arrow_direction
		main.add_child(A)

func atack1():
	var random_atack = randi() % 3
	match random_atack:
		0:
			state_machine.travel('Atack1')
			attack_power = 30 * player_light.scale.x
		1:
			state_machine.travel('Atack2') 
			attack_power = 40 * player_light.scale.x
		2:
			state_machine.travel('Atack3') 
			attack_power = 50 * player_light.scale.x
	sword_sound.play()
		
func jump():
	jump_sound.play()
	velocity.y = JUMP_VELOCITY
	state_machine.travel('Jump')
	
func iddle():
	state_machine.travel('Idle')

#GAMEOVER FUNCTION
func game_over ():
	#PENDING FIX FUNCTIoN NAME (NOT GAMEOVER) DIE LIVES
	update_lives(1)
	get_tree().reload_current_scene()

#QUIT GAME FUNCTION
func game_quit ():
		get_tree().change_scene_to_file("res://Objects/menu.tscn")
	
#ADD SCORE FUNCTION
func add_score (amount):
	score += amount
	score_text.text = str("Score: ", score)
	
#UPDATE LIVES FUNCTION
func update_lives (amount):
	lives -= amount
	print(lives)
	lives_text.text = str("Lives: ", lives)
	
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
		state = "Hurt"
		state_machine.travel('Hurt')
		live -= damage
		hurt_sound.play()
		$ProgressBar.value = live
		progress_bar.value = live
		
		#FIX Random size
		var offset_position = randi() % 20
		var main = get_tree().current_scene
		var D = DamageIndicator.instantiate()
		var color = "white"
		D.global_position = Vector2(global_position.x - offset_position, (global_position.y/10) - offset_position)
		D.show_damage(damage, color)
		main.add_child(D)

		if live <= 0:
			game_over()
		
func explode():
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		body.hurt(attack_power)


func _on_area_2d_area_entered(area):
	if area.is_in_group("enemies"):
		area.hurt(attack_power)

	if area.is_in_group("door"):
		print("Door entered")
		get_tree().change_scene_to_file("res://Objects/Level1Boss.tscn")
		


