extends Area2D

const SPEED = 200.0
const DISTANCE_THRESHOLD = 200  # Distancia mínima para perseguir al jugador
const DISTANCE_ATACK = 50

var state : String = "Idle"
var target_position : Vector2
var timer : float = 0
@export var live : int = 200
@export var ArrowDamage_sound : AudioStreamPlayer2D


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
		"Idle":
			if timer > 1.0:
				var random_choice = randi() % 3
				match random_choice:
					0:
						target_position = global_position + Vector2(randf_range(-50, -150), 0)
						state = "WalkingLeft"
						$AnimationPlayer.play("Run")
					1:
						target_position = global_position + Vector2(randf_range(50, 150), 0)
						state = "WalkingRight"
						$AnimationPlayer.play("Run")
					2:
						state = "Idle"
						timer = 0
						position = position
						$AnimationPlayer.play("Iddle")
						
						


		"WalkingLeft":
			position -= transform.x * SPEED * delta
			get_node( "Sprite2D" ).set_flip_h( true )
			$AnimationPlayer.play("Run")
			if global_position.x < target_position.x or timer > 3.0:
				state = "Idle"
				timer = 0

		"WalkingRight":
			position += transform.x * SPEED * delta
			get_node( "Sprite2D" ).set_flip_h( false )
			$AnimationPlayer.play("Run")
			if global_position.x > target_position.x or timer > 3.0:
				state = "Idle"
				timer = 0
				


		"ChasePlayer":
			var direction = (player.global_position - global_position).normalized()
			if direction.x > 0:
				get_node( "Sprite2D" ).set_flip_h( false )
				$AnimationPlayer.play("Run")
			else:
				get_node( "Sprite2D" ).set_flip_h( true )
				$AnimationPlayer.play("Run")	
			
			position += transform.x * direction * SPEED * delta
			$AnimationPlayer.play("Run")
			if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD:
				state = "Idle"
				
		"Atack":
			timer = 0
			position = position
			
			var direction = (player.global_position - global_position).normalized()
			if direction.x > 0:
				get_node( "Sprite2D" ).set_flip_h( false )
				$AnimationPlayer.play("atack")
			else:
				get_node( "Sprite2D" ).set_flip_h( true )
				$AnimationPlayer.play("atack")
			if global_position.distance_to(player.global_position) < DISTANCE_THRESHOLD:
				state = "Idle"


func _on_body_entered(body):
		if body.is_in_group("Player"):
			body.hurt(10)
			
func hurt(damage):
		ArrowDamage_sound.play()
		live -= damage
		$ProgressBar.value = live
		state = "ChasePlayer"
		
func explode():
	pass
		


func _on_animation_finished(animation_name):
	# Esta función se llama cuando cualquier animación en el AnimationPlayer se completa
	if animation_name == "atack":
		print("Animación de ataque completada. Realizando acciones adicionales.")
		# Realiza aquí las acciones adicionales después de que la animación de ataque se complete
		# Puedes cambiar el estado del enemigo o realizar otras acciones
		state = "Idle"  # Cambia el estado a "Idle" después de completar la animación de ataque
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "atack":
		print("Atack")
		state = "Idle"
	
