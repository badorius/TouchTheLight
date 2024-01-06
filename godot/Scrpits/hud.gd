extends CanvasLayer

@export var lives : int = 3
@export var score : int = 0
@export var arrows : int = 0
@export var boots : int = 0
@export var coat : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	lives = 3
	score = 0
	arrows = 0
	coat = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_lives(num):
	lives -= num
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
	$ScoreText.text = str("Score: ", score)
	
	
func update_arrows(num):
	arrows += num
	if arrows > 0:
		$skills/ArrowsDecor/arrows.visible = true
		$skills/ArrowsDecor/LabelArrows.text = str(arrows)
	else:
		$skills/ArrowsDecor/arrows.visible = false
		$skills/ArrowsDecor/LabelArrows.text = str(arrows)
		
func update_boots(num):
	boots += num
	if boots > 0:
		$skills/BootsDecor/boots.visible = true
		$skills/BootsDecor/LabelBoots.text = str(boots)
	else:
		$skills/BootsDecor/boots.visible = false
		$skills/BootsDecor/LabelBoots.text = str(boots)
		

func update_coat(num):
	coat += num
	if coat > 0:
		$skills/CoatDecor/coat.visible = true
		$skills/CoatDecor/LabelCoat.text = str(coat)
	else:
		$skills/CoatDecor/coat.visible = true
		$skills/CoatDecor/LabelCoat.text = str(coat)

func update_magic1 (mana):
	$skills/Magic1Decor/LabelMagic1.text = str(mana)
	if mana > 0:
		$skills/Magic1Decor/magic1.visible = true
	else:
		$skills/Magic1Decor/magic1.visible = false

func update_magic2 (mana):
	$skills/Magic2Decor/LabelMagic2.text = str(mana)
	if mana > 0:
		$skills/Magic2Decor/magic2.visible = true
	else:
		$skills/Magic2Decor/magic2.visible = false
		
func update_magic3 (mana):
	$skills/Magic3Decor/LabelMagic3.text = str(mana)
	if mana > 0:
		$skills/Magic3Decor/magic3.visible = true
	else:
		$skills/Magic3Decor/magic3.visible = false
