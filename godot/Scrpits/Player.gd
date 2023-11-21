extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var score : int = 0
@onready var score_text : Label = get_node("../CanvasLayer/ScoreText")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("ui_fire1"):
		$AnimationPlayer.play("BowShooting")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		if direction:
			if direction == -1:
				get_node( "Warrior" ).set_flip_h( false )
				velocity.x = direction * SPEED
				$AnimationPlayer.play("WalkRight")
			if direction == 1:
				velocity.x = direction * SPEED
				get_node( "Warrior" ).set_flip_h( true )
				$AnimationPlayer.play("WalkRight")
				
		else:
			$AnimationPlayer.stop()
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("ui_cancel") and is_on_floor():
		game_quit()
	
	if global_position.y > 250:
		game_over()

func game_over ():
	get_tree().reload_current_scene()
	
func game_quit ():
	get_tree().quit(0)
	
func add_score (amount):
	score += amount
	score_text.text = str("Score: ", score)
