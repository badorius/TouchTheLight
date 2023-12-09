extends CharacterBody2D

const SPEED = 200.0
const DISTANCE_THRESHOLD = 200  # Distancia mínima para perseguir al jugador
const DISTANCE_ATACK = 50
const JUMP_VELOCITY = -350.0

var state : String = "idle"
var target_position : Vector2
var timer : float = 0
@export var live : int = 200
@export var ArrowDamage_sound : AudioStreamPlayer2D
@onready var player : CharacterBody2D = get_node("/root/Main/Player")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	ArrowDamage_sound = $ArrowDamage

	
func _process(delta):
	$ProgressBar.value = live


func _physics_process(delta):
	timer += delta
	var player = get_parent().get_node("Player")
		#CHECK DISTANCE TO CHESE OR ATACK
	if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD:
		state = "ChasePlayer"
		if global_position.distance_to(player.global_position) < DISTANCE_ATACK:
			state = "Atack"
	

		
	match state:
		"idle":
			if timer > 1.0:
				var random_choice = randi() % 4
				match random_choice:
					0:
						target_position = global_position + Vector2(randf_range(-50, -150), 0)
						state = "WalkingLeft"
						$AnimatedSprite2D.play("run")
					1:
						target_position = global_position + Vector2(randf_range(50, 150), 0)
						state = "WalkingRight"
						$AnimatedSprite2D.play("run")
					2:
						state = "idle"
						timer = 0
						position = position
						$AnimatedSprite2D.play("idle")
					3:
						state = "jump"
						$AnimatedSprite2D.play("run")
						
						


		"WalkingLeft":
			velocity.x = -SPEED
			get_node( "AnimatedSprite2D" ).set_flip_h( true )
			$AnimatedSprite2D.play("run")
			if global_position.x < target_position.x or timer > 3.0:
				state = "idle"
				timer = 0
				position = position
				$AnimatedSprite2D.play("idle")


		"WalkingRight":
			velocity.x = SPEED
			get_node( "AnimatedSprite2D" ).set_flip_h( false )
			$AnimatedSprite2D.play("run")
			if global_position.x > target_position.x or timer > 3.0:
				state = "idle"
				timer = 0
				position = position
				$AnimatedSprite2D.play("idle")
				
				
		"jump":
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				state = "jump"
			else:
				state = "idle"
				timer = 0
				position = position
				$AnimatedSprite2D.play("idle")

		"ChasePlayer":
			var direction = (player.global_position - global_position).normalized()
			velocity= direction * SPEED
			if direction.x > 0:
				get_node( "AnimatedSprite2D" ).set_flip_h( false )
				$AnimatedSprite2D.play("run")
			else:
				get_node( "AnimatedSprite2D" ).set_flip_h( true )
				$AnimatedSprite2D.play("run")
			if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD:
				state = "idle"
				timer = 0
				position = position
				$AnimatedSprite2D.play("idle")
				
		"Atack":
			timer = 0
			position = position
			var direction = (player.global_position - global_position).normalized()
			if direction.x > 0:
				get_node( "AnimatedSprite2D" ).set_flip_h( false )
				$AnimatedSprite2D.play("atack")
				player.hurt(1)
				print ("atack")
			else:
				get_node( "AnimatedSprite2D" ).set_flip_h( true )
				$AnimatedSprite2D.play("atack")
				player.hurt(1)
				print ("atack")
				
			if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD:
				state = "idle"
				timer = 0
				position = position
				$AnimatedSprite2D.play("idle")

	move_and_slide()


func _on_body_entered(body):
		if body.is_in_group("Player"):
			body.hurt(0.1)
			
func hurt(damage):
		ArrowDamage_sound.play()
		$AnimatedSprite2D.play("hurt")
		live -= damage
		$ProgressBar.value = live
		state = "ChasePlayer"
		
func explode():
	pass
		
func death():
	$AnimatedSprite2D.play("death")

func _on_animated_sprite_2d_animation_finished():

		await  $AnimatedSprite2D.animation_finished
		print("Atack")
		state = "idle"
		timer = 0
		position = position
		$AnimatedSprite2D.play("idle")

		await  $AnimatedSprite2D.animation_finished
		print("hurt")
		state = "idle"
		timer = 0
		position = position
		$AnimatedSprite2D.play("idle")

		await  $AnimatedSprite2D.animation_finished
		print("death")
		state = "idle"
		timer = 0
		position = position
		$AnimatedSprite2D.play("idle")
	
