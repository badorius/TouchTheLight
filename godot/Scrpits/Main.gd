extends Node2D

#Load tscn

@onready var Menu = preload("res://Objects/Levels/menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	MainMenu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func MainMenu():
	var MenuInstance = Menu.instantiate()
	add_child(MenuInstance)
	#get_tree().change_scene_to_file("res://Objects/Levels/menu.tscn")

func ChangeLevel(Level):	
	match Level:
		"1":
			get_tree().change_scene_to_file("res://Objects/Levels/Level1.tscn")
		"2":
			get_tree().change_scene_to_file("res://Objects/Levels/Level2.tscn")
