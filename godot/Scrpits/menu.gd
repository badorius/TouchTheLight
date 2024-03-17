extends Control

var direction = 1
var base_speed = 5
var speed = base_speed
var mouse_over : AudioStreamPlayer2D
#@onready var Main : Node2D = get_node("../../Main") 
#@onready var Main : Node2D = get_pa get_node("") 

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_over = $MouseOver
	print(get_tree())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if direction == 1:
		if $Player.position.x < 2300:
			get_node( "Player/Warrior" ).set_flip_h( true )
			$Player/AnimationPlayer.play("WalkRight")
			$Player.position.x += speed
		
			get_node( "skeleton/Walk" ).set_flip_h( false )
			$skeleton/AnimationPlayer.play("Walk")
			$skeleton.position.x += speed
	
		else:
			direction = -1
			
			
	if direction == -1:
		speed = base_speed * 2
		if $Player.position.x > -1500:
			get_node( "Player/Warrior" ).set_flip_h( false )
			$Player/AnimationPlayer.play("WalkRight")
			$Player.position.x -= speed
		
			get_node( "skeleton/Walk" ).set_flip_h( true )
			$skeleton/AnimationPlayer.play("Walk")
			$skeleton.position.x -= speed
			
			get_node( "FlayingEye/Sprite2D" ).set_flip_h( true )
			$FlayingEye/AnimationPlayer.play("Run")
			$FlayingEye.position.x -= speed
		
			get_node( "NightBorne/Sprite2D" ).set_flip_h( true )
			$NightBorne/AnimationPlayer.play("Run")
			$NightBorne.position.x -= speed
		else:
			$NightBorne.position.x = 3597
			$FlayingEye.position.x = 3174
			direction = 1
			speed = base_speed


func _on_start_button_pressed():
	#Main.ChangeLevel(1)
	get_tree().change_scene_to_file("res://Objects/Levels/Level1.tscn")

func _on_settings_button_pressed():
	$Popup.visible = true
	#get_tree().change_scene_to_file("res://Objects/options.tscn")

func _on_quit_button_pressed():
	get_tree().quit(0)

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Objects/Levels/Thanks.tscn")
	
func _on_start_button_mouse_entered():
	mouse_over.play()

func _on_settings_button_mouse_entered():
	mouse_over.play()

func _on_quit_button_mouse_entered():
	mouse_over.play()
	
func _on_credits_button_mouse_entered():
	mouse_over.play()
	
