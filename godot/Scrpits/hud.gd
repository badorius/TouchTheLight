extends CanvasLayer

@export var lives : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	lives = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	



func update_lives(num):
	lives -= num
	print(lives)
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

