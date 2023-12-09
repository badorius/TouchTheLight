extends CharacterBody2D

const SPEED = 200.0
const DISTANCE_THRESHOLD = 100  # Distancia mínima para perseguir al jugador
const DISTANCE_ATACK = 40
const JUMP_VELOCITY = -350.0

var state : String = "idle"
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
			state = "Atack"
			

			
func _physics_process(delta):
	timer += delta

	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		#state = "idle"
		
	match state:
		"idle":
			$AnimatedSprite2D.play("idle")
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
						state = "idle"
						timer = 0
					3:
						state = "jump"
						
						
		"WalkingLeft":
			velocity.x = -SPEED
			get_node( "AnimatedSprite2D" ).set_flip_h( true )
			$AnimatedSprite2D.play("run")
			if global_position.x < target_position.x or timer > 3.0:
				state = "idle"
				timer = 0
				$AnimatedSprite2D.play("idle")


		"WalkingRight":
			velocity.x = SPEED
			get_node( "AnimatedSprite2D" ).set_flip_h( false )
			$AnimatedSprite2D.play("run")
			if global_position.x > target_position.x or timer > 3.0:
				state = "idle"
				timer = 0
				$AnimatedSprite2D.play("idle")
				
				
		"jump":
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				state = "jump"
			else:
				state = "idle"
				timer = 0
				$AnimatedSprite2D.play("idle")

		"ChasePlayer":
			var direction = (player.global_position - global_position).normalized()
			if direction.x > 0:
				get_node( "AnimatedSprite2D" ).set_flip_h( false )
				velocity = direction * SPEED
				$AnimatedSprite2D.play("run")
			else:
				get_node( "AnimatedSprite2D" ).set_flip_h( true )
				velocity = direction * SPEED
				$AnimatedSprite2D.play("run")
				
			if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD:
				state = "idle"
				timer = 0
				$AnimatedSprite2D.play("idle")
				
				
		"Atack":
			timer = 0
			var direction = (player.global_position - global_position).normalized()
			if direction.x > 0:
				get_node( "AnimatedSprite2D" ).set_flip_h( false )
				$AnimatedSprite2D.animation = "atack"
				await $AnimatedSprite2D.animation_finished

			else:
				get_node( "AnimatedSprite2D" ).set_flip_h( true )
				$AnimatedSprite2D.animation = "atack"
				await $AnimatedSprite2D.animation_finished


				
			if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD:
				state = "idle"
				timer = 0
				$AnimatedSprite2D.play("idle")
				
				
	move_and_slide()



			
func hurt(damage):
		ArrowDamage_sound.play()
		$AnimatedSprite2D.play("hurt")
		live -= damage
		$ProgressBar.value = live
		state = "ChasePlayer"
		
func explode():
	pass
		
func death():
	$AnimatedSprite2D.animation = "death"
	$AnimatedSprite2D.play("death")
	$AnimatedSprite2D.animation_finished
	queue_free()


func _on_animated_sprite_2d_animation_finished():
	
	if ($AnimatedSprite2D.animation == "atack"):
		$AnimatedSprite2D.play("atack")
		player.hurt(10)
		print("Player hurt")
		
	if ($AnimatedSprite2D.animation == "death"):
		$AnimatedSprite2D.play("death")
		print("enemy death")


	
	
			
