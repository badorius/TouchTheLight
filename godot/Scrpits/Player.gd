extends CharacterBody2D

const MINSPEED = 100
@export var SPEED = MINSPEED
const MAXSPEED = 250
const JUMP_VELOCITY = -350.0
@export var push_force = 80.0


var max_live : int = 213
var max_mana : float = 213.0
@export var live : int = max_live
@export var mana : float = 0.0
@export var arrows : int = 0
@export var coat : int = 0

var state_machine
@export var state : String = "Idle"
@export var attack_power : int  = 10
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#Var for double jump
var can_doublejump = true 
@export var direction = Input.get_axis("ui_left", "ui_right")


#HUD VARS
@onready var live_sphere : TextureProgressBar = get_node("../HUD/Live/Control/ProgressBarLive") 
@onready var mana_sphere : TextureProgressBar = get_node("../HUD/Mana/Control/ProgressBarMana") 
@onready var HUD : CanvasLayer = get_node("../HUD") 
@export var score : int = 0
@export var lives : int = 3

# CAMERA VAR TO CONTROL CAM FUNCTIONS AND EFECTS
@onready var MainCam : Camera2D = get_node("../Camera2D") 

#Load Arrow and magic tscn
const Arrow = preload("../Objects/Arrow.tscn")
const Magic1 = preload("../Objects/Magic1.tscn")
const Magic2 = preload("../Objects/Magic2.tscn")
const Magic3 = preload("../Objects/Magic3.tscn")
const DamageIndicator = preload("../Objects/damage_indicator.tscn")
@export var arrow_direction : int = 1
const Explode = preload("../Objects/PlayerExplode.tscn")

# Light vaule default
var base_light : Vector2 = Vector2(0.5, 0.5)
@export var decrease_value : Vector2 = Vector2(0.001, 0.001)
@export var max_light : Vector2 = Vector2(2.0, 2.0)
# Referencia al PointLight2D
@export var player_light : PointLight2D
#  CHECKPOINT POSITION
@export var checkpoint_position : Vector2


#Sounds
var jump_sound : AudioStreamPlayer2D
var arrow_sound : AudioStreamPlayer2D 
var dash_sound : AudioStreamPlayer2D
var hurt_sound : AudioStreamPlayer2D
var sword_sound : AudioStreamPlayer2D
var death_sound : AudioStreamPlayer2D


func _ready():
	state = "Iddle"
	$Warrior/Area2DSword/HitSword.visible = false
	state_machine = $AnimationTree.get('parameters/playback')
	state_machine.travel('Idle')
	live_sphere.value = live
	SPEED = MINSPEED
	$Warrior/PointLight2D.visible = true

	# Utiliza get_node para acceder al nodo "Warrior" y luego al nodo "PointLight2D" dentro de él
	player_light = $Warrior/PointLight2D
	#Set default sword collision disabled
	$Warrior/Area2DSword/CollisionShape2D.disabled = true
	# Establecer la escala de la luz al valor base al iniciar
	player_light.scale = base_light

	#SONIDOS
	jump_sound = $Jump
	arrow_sound = $arrow
	dash_sound = $dash
	hurt_sound = $Hurt
	sword_sound = $sword
	death_sound = $Death
	
func _physics_process(delta):
		
	if state != "Hurt":
		direction = Input.get_axis("ui_left", "ui_right")
		
	# Get the input direction and handle the movement/deceleration and orientation.
	if direction:
		arrow_direction = direction

	if state == "Hurt":
		bounce()
		
	if direction and state != "Hurt":
		state = "WalkRight"
		walk(direction)
		if direction == -1:
			get_node( "Warrior" ).set_flip_h( false )
			$Warrior/Area2DSword.position.x = -34

		if direction == 1:
			get_node( "Warrior" ).set_flip_h( true )
			$Warrior/Area2DSword.position.x = 0

			
		# Slide Down
		if Input.is_action_pressed("ui_down"):
			slide(direction)
		else:
			walk(direction)
			
			
	else:
		if state != "Hurt":
			velocity.x = move_toward(velocity.x, 0, SPEED)
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
		can_doublejump = true
		jump()
	elif Input.is_action_just_pressed("ui_accept") and !is_on_floor() and can_doublejump and coat > 0:
		state = "Jump"
		can_doublejump = false
		update_coat(-1)
		jump()


	# Fire BOW
		# Sword Atack
	if Input.is_action_just_pressed("ui_fire1"):
		state = "Atack1"
		atack1()
	
	if Input.is_action_just_pressed("ui_fire2"):
		state = "BowShooting"
		bowing(arrow_direction)
		
	# Magic Atack
	if Input.is_action_just_pressed("ui_fire3"):
		state = "Magic1"
		magic1(arrow_direction)
		
	# Magic Atack
	if Input.is_action_just_pressed("ui_fire4"):
		state = "Magic2"
		magic2(arrow_direction)
		
	# Magic Atack
	if Input.is_action_just_pressed("ui_fire5"):
		state = "Magic3"
		magic3(arrow_direction)
		
			
	move_and_slide()
	# Add pushforce to rigibody #after calling move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
	#Decrease light
	decrease_light_scale(0.01)
	
	#QUIT GAME
	if Input.is_action_just_pressed("ui_cancel") and is_on_floor():
		game_quit()
	
	#PLAYER DOWN GAMEOVER
	if global_position.y > 500:
		#$AnimationPlayer.play("Death")
		death_sound.play()
		reset_skills()
		gotocheckpoint()


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
	if arrows > 0:
		update_arrows(-1)
		arrow_sound.play()
		var main = get_tree().current_scene
		var A = Arrow.instantiate()
		A.global_position = global_position
		if arrow_direction == 1:
			A.position.x = global_position.x + 15
		else:
			A.position.x = global_position.x - 45
		A.position.y = global_position.y + 15
		A.direction = arrow_direction
		main.add_child(A)
		
		
#FUNC MAGIC
func magic1(arrow_direction):
	state_machine.travel('BowShooting')
	if mana > 0:
		update_magic1()
		arrow_sound.play()
		decrease_light_scale(5.0)
		var main = get_tree().current_scene
		var A = Magic1.instantiate()
		A.global_position = global_position
		if arrow_direction == 1:
			A.position.x = global_position.x + 15
		else:
			A.position.x = global_position.x - 45
		A.position.y = global_position.y + 15
		A.direction = arrow_direction
		main.add_child(A)

func magic2(arrow_direction):
	state_machine.travel('BowShooting')
	if mana > 0:
		update_magic2()
		arrow_sound.play()
		decrease_light_scale(50.0)
		var main = get_tree().current_scene
		var A = Magic2.instantiate()
		A.global_position = global_position
		if arrow_direction == 1:
			A.position.x = global_position.x + 15
		else:
			A.position.x = global_position.x - 45
		A.position.y = global_position.y + 15
		A.direction = arrow_direction
		main.add_child(A)

func magic3(arrow_direction):
	state_machine.travel('BowShooting')
	if mana > 0:
		update_magic3()
		arrow_sound.play()
		decrease_light_scale(5.0)
		var main = get_tree().current_scene
		var A = Magic3.instantiate()
		A.global_position = global_position
		if arrow_direction == 1:
			A.position.x = global_position.x + 15
		else:
			A.position.x = global_position.x - 45
		A.position.y = global_position.y + 15
		A.direction = arrow_direction
		main.add_child(A)

func atack1():
	var random_atack = randi() % 3
	match random_atack:
		0:
			state_machine.travel('Atack1')
			attack_power = 90 * ((mana / 100) + 1)
		1:
			state_machine.travel('Atack2') 
			attack_power = 120 * ((mana / 100) + 1)
		2:
			state_machine.travel('Atack3') 
			attack_power = 150 * ((mana / 100) + 1)


		
func jump():
	jump_sound.play()
	velocity.y = JUMP_VELOCITY
	state_machine.travel('Jump')

		
func iddle():
	state_machine.travel('Idle')

#GAMEOVER FUNCTION
func game_over ():
	#PENDING FIX FUNCTIoN NAME (NOT GAMEOVER) DIE LIVES
	HUD.gameover()
	#get_tree().change_scene_to_file("res://Objects/menu.tscn")

#QUIT GAME FUNCTION
func game_quit ():
		get_tree().change_scene_to_file("res://Objects/menu.tscn")
	
#ADD SCORE FUNCTION
func add_score (amount):
	HUD.update_score(amount)
	
func update_arrows (amount):
	if amount == 0:
		arrows = 0
	else:
		arrows += amount
		
	HUD.update_arrows(amount)
	
func update_boots (amount):
	if amount == 0:
		SPEED = MINSPEED
		HUD.update_boots(amount)
	else:
		if SPEED < MAXSPEED:
			SPEED += amount
	HUD.update_boots(amount)
		
func update_coat (amount):
	if amount == 0:
		coat = 0
	else:
		coat += amount
	HUD.update_coat(amount)

func update_magic1 ():
	HUD.update_magic1(int(mana))

func update_magic2 ():
	HUD.update_magic2(int(mana))

func update_magic3 ():
	HUD.update_magic3(int(mana))
	
#UPDATE LIVES FUNCTION
func update_lives (amount):
	if lives == 0:
		game_over()
	else:
		live = max_live
		live_sphere.value = live
		mana_sphere.value = 0.0
		lives -= amount
		HUD.update_lives(amount)

	
# Función para incrementar la escala de la luz
func increment_light_scale(increment_amount):
	if mana < 213.0:
		mana += increment_amount
		mana_sphere.value += increment_amount
		mana_sphere.value = mana
		
		if player_light.scale < max_light:
			player_light.scale += Vector2(increment_amount/100, increment_amount/100)

	if mana > 0:
		update_magic1()
		update_magic2()
		update_magic3()


func decrease_light_scale(decrease_amount):
	if mana > 0.0:
		mana -= decrease_amount
		mana_sphere.value -= decrease_amount
		mana_sphere.value = mana
		
		if player_light.scale >= base_light:
			player_light.scale -= Vector2(decrease_amount/100, decrease_amount/100)

	if mana > 0:
		update_magic1()
		update_magic2()
		update_magic3()
		
func do_hurt():
	pass
	#player.hurt(attack_power)

func hurt(damage):
		#MainCam.shake_window()
		state = "Hurt"
		state_machine.travel('Hurt')
		live -= damage
		hurt_sound.play()
		live_sphere.value = live
		
		#FIX Random size
		var offset_position = randi() % 20
		var main = get_tree().current_scene
		var D = DamageIndicator.instantiate()
		var color = "white"
		D.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
		D.show_damage(damage, color)
		main.add_child(D)

		
		if live <= 0:
			$AnimationPlayer.play("Death")
			death_sound.play()
			update_lives(1)
			reset_skills()

#PENDING FIX GOOD BOUNCE EFECT SEE BOUNCE GODOT
func bounce():
	#state_machine.travel('HurtCollide')
	if arrow_direction == 1:
		velocity.x = -100
	else:
		velocity.x = 100

func reset_skills():
	live = max_live
	live_sphere.value = live
	mana = 0
	mana_sphere.value = mana
	player_light.scale = base_light
	HUD.update_magic1(0)
	HUD.update_magic2(0)
	HUD.update_magic3(0)
	update_arrows(0)
	update_boots(0)
	update_coat(0)
	
		
func explode():
		var main = get_tree().current_scene
		var A = Explode.instantiate()
		A.global_position = global_position
		main.add_child(A)


func gotocheckpoint():
	state = "Iddle"
	position = checkpoint_position

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		body.hurt(attack_power)
		$AnimationPlayer.play("HitSword")


func _on_area_2d_area_entered(area):
	if area.is_in_group("enemies"):
		
		area.hurt(attack_power)

	if area.is_in_group("door"):
		get_tree().change_scene_to_file("res://Objects/Level1Boss.tscn")
		

func _on_area_2d_body_body_entered(body):
	if body.is_in_group("enemies"):
		body.hurt(10)
		hurt(10)

