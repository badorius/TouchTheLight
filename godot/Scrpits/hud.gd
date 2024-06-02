extends CanvasLayer

@export var lives : int = 3
@export var score : int = 0
@export var max_score : int = 10000
@export var timer : float = 300.0
@export var arrows : int = 0
@export var boots : int = 0
@export var coat : int = 0
@onready var player : CharacterBody2D = get_node("../Player")
#@export var magic : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	lives = 3
	score = 0
	arrows = 0
	coat = 0
	$GameOver.visible = false
	$VBoxContainer.visible = false
	$BloodCloudBloodOverlay.visible = false
	$MaxScore.text = str("TOP SCORE: ", max_score)
	$skills/ArrowsDecor/arrows0.visible = false
	$skills/ArrowsDecor/arrows1.visible = false
	$skills/ArrowsDecor/arrows2.visible = false
	$skills/ArrowsDecor/arrows3.visible = false
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_lives(num):
	$AnimationPlayer.play("Death")
	lives += num
	match lives:
		0:
			$BoxContainer/IconLives1.visible = false
			$BoxContainer/IconLives2.visible = false
			$BoxContainer/IconLives3.visible = false
		1:
			$BoxContainer/IconLives1.visible = false
			$BoxContainer/IconLives2.visible = false
			$BoxContainer/IconLives3.visible = true
		2:
			$BoxContainer/IconLives1.visible = false
			$BoxContainer/IconLives2.visible = true
			$BoxContainer/IconLives3.visible = true
		3:
			$BoxContainer/IconLives1.visible = true
			$BoxContainer/IconLives2.visible = true
			$BoxContainer/IconLives3.visible = true
			
func update_score(num):
	score += num
	$ScoreText.text = str("SCORE: ", score)
	update_max_score()
	
func update_max_score():
	if score > max_score:
		max_score = score
		$MaxScore.text = str("TOP SCORE: ", max_score)

	
func update_timer():
	timer -= 0.02
	$Timer.text = str("TIMER: ", int(timer))
	if timer <= 0:
		reset_timer()
		player.death()
		
func reset_timer():
	timer = 300.0

func get_boots():
	return boots/10
func get_coat():
	return coat/10
func get_arrows():
	return arrows/10

func update_arrows(num, magic):
	if num == 0:
		arrows = 0
	else:
		arrows += num
		
	if arrows > 0:
		match magic:
			0:
				$skills/ArrowsDecor/arrows0.visible = true
				$skills/ArrowsDecor/arrows1.visible = false
				$skills/ArrowsDecor/arrows2.visible = false
				$skills/ArrowsDecor/arrows3.visible = false
			1:
				$skills/ArrowsDecor/arrows0.visible = false
				$skills/ArrowsDecor/arrows1.visible = true
				$skills/ArrowsDecor/arrows2.visible = false
				$skills/ArrowsDecor/arrows3.visible = false
			2:
				$skills/ArrowsDecor/arrows0.visible = false
				$skills/ArrowsDecor/arrows1.visible = false
				$skills/ArrowsDecor/arrows2.visible = true
				$skills/ArrowsDecor/arrows3.visible = false
			3:
				$skills/ArrowsDecor/arrows0.visible = false
				$skills/ArrowsDecor/arrows1.visible = false
				$skills/ArrowsDecor/arrows2.visible = false
				$skills/ArrowsDecor/arrows3.visible = true
		
		$skills/ArrowsDecor/LabelArrows.text = str(arrows)
	else:
		$skills/ArrowsDecor/arrows0.visible = false
		$skills/ArrowsDecor/arrows1.visible = false
		$skills/ArrowsDecor/arrows2.visible = false
		$skills/ArrowsDecor/arrows3.visible = false
		$skills/ArrowsDecor/LabelArrows.text = str(arrows)
		
func update_boots(num):
	if num == 0:
		boots = 0
	else:
		boots += num

	if boots > 0:
		$skills/BootsDecor/boots.visible = true
		$skills/BootsDecor/LabelBoots.text = str(boots)
	else:
		$skills/BootsDecor/boots.visible = false
		$skills/BootsDecor/LabelBoots.text = str(boots)
		

func update_coat(num):
	if num == 0:
		coat = 0
	else:
		coat += num
	
	if coat > 0:
		$skills/CoatDecor/coat.visible = true
		$skills/CoatDecor/LabelCoat.text = str(coat)
	else:
		$skills/CoatDecor/coat.visible = true
		$skills/CoatDecor/LabelCoat.text = str(coat)


func gameover():
	$GameOver.visible = true
	$VBoxContainer.visible = true
	$AnimationPlayer.play("GameOver")
	
func death():
	$AnimationPlayer.play("Death")
	
	
	
func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://Objects/Levels/options.tscn")
	
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Objects/Levels/Level1.tscn")

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://Objects/Levels/menu.tscn")

func _on_buton_sword_pressed():
	player.atack1()
	
func _on_buton_arrows_pressed():
	pass # Replace with function body.
	
func _on_buton_magic_1_pressed():
	pass # Replace with function body.

func _on_buton_magic_2_pressed():
	pass # Replace with function body.

func _on_buton_magic_3_pressed():
	pass # Replace with function body.



