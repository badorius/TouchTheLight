extends Node2D

#Load tscn

const Menu = preload("res://Objects/Levels/menu.tscn")
const Options = preload("res://Objects/Levels/options.tscn")
const Pause = preload("res://Objects/Levels/Pause.tscn")
const Thanks = preload("res://Objects/Levels/Thanks.tscn")
const Level1 = preload("res://Objects/Levels/Level1.tscn")
const Gameover = preload("res://Objects/Levels/GameOver.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	MainMenu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func MainMenu():
	get_tree().change_scene_to_file("res://Objects/Levels/menu.tscn")
