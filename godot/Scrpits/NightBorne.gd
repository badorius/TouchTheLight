extends CharacterBody2D

const SPEED = 200.0
var AttackCount = 3
const DISTANCE_THRESHOLD = 100  # Distancia mínima para perseguir al jugador
const DISTANCE_ATACK = 40
const JUMP_VELOCITY = -350.0
var state_machine
var state : String = "Iddle"
var target_position : Vector2
var timer : float = 0
@export var live : int = 200
@export var ArrowDamage_sound : AudioStreamPlayer2D
@onready var player : CharacterBody2D = get_node("../Player")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	ArrowDamage_sound = $ArrowDamage
	#var player = get_parent().get_node("Player")

	
func _process(delta):
	$ProgressBar.value = live
	#CHECK DISTANCE TO CHESE OR ATACK
	if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD:
		state = "ChasePlayer"
		if global_position.distance_to(player.global_position) < DISTANCE_ATACK:
			state = "Attack"

	
func _physics_process(delta):

	timer += delta
	state_machine = $AnimationTree.get('parameters/playback')
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	match state:
		"Iddle":
			state_machine.travel('Start')
			if timer > 1.0:
				var random_choice = randi() % 4
				match random_choice:
					0:
						target_position = global_position + Vector2(randf_range(-50, -150), 0)
						state = "WalkingLeft"
					1:
						target_position = global_position + Vector2(randf_range(50, 150), 0)
						state = "WalkingRight"
					2:
						state = "Iddle"
						timer = 0
					3:
						state = "Jump"
						
						
		"WalkingLeft":
			velocity.x = -SPEED
			get_node( "Sprite2D" ).set_flip_h( true )
			state_machine.travel('Run')
			if global_position.x < target_position.x or timer > 3.0:
				state = "Iddle"
				timer = 0
				state_machine.travel('Start')



		"WalkingRight":
			velocity.x = SPEED
			get_node( "Sprite2D" ).set_flip_h( false )
			state_machine.travel('Run')
			if global_position.x > target_position.x or timer > 3.0:
				state = "Iddle"
				timer = 0
				state_machine.travel('Start')

				
		"Jump":
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				state = "Jump"
			else:
				state = "Iddle"
				timer = 0
				state_machine.travel('Start')


		"ChasePlayer":
			var direction = (player.global_position - global_position).normalized()
			if direction.x > 0:
				get_node( "Sprite2D" ).set_flip_h( false )
				velocity = direction * SPEED
			else:
				get_node( "Sprite2D" ).set_flip_h( true )
				velocity = direction * SPEED

			state_machine.travel('Run')	
			if global_position.distance_to(player.global_position) > DISTANCE_THRESHOLD:
				state = "Iddle"
				timer = 0
				state_machine.travel('Start')
							
				
				
				
		"Attack":
			timer = 0
			var direction = (player.global_position - global_position).normalized()
			if direction.x > 0:
				get_node( "Sprite2D" ).set_flip_h( false )
			else:
				get_node( "Sprite2D" ).set_flip_h( true )
			state_machine.travel('Attack')
			if global_position.distance_to(player.global_position) > DISTANCE_THRESHOLD:
				state = "Iddle"
				timer = 0
				state_machine.travel('Start')
							
							

		


	move_and_slide()



			
func hurt(damage):
		ArrowDamage_sound.play()
		state_machine.travel('Hurt')
		live -= damage
		$ProgressBar.value = live
		state = "ChasePlayer"
		
func explode():
	pass
		
func death():
	state_machine.travel('Death')
	queue_free()





	
	
			
