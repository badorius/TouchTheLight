extends Node2D

const FireBall = preload("../Objects/Efects/fire_ball.tscn")
const TOTAL_BALLS = 10
var balls = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if balls <= TOTAL_BALLS:
		var RunBall = randi() % 50
		if RunBall == 1:
			instance_ball()
			balls += 1
	else:
		queue_free()


func instance_ball():
	var main = get_tree().current_scene
	var offset_position = randi() % 800
	# Instatnce new enmies and Drop enemies
	var EnemyDrop = FireBall.instantiate()
	EnemyDrop.global_position = Vector2(global_position.x  + offset_position , (global_position.y) - offset_position * 5)
	main.add_child(EnemyDrop)


