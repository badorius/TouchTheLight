extends Node2D

@onready var bgmusic : AudioStreamPlayer2D = get_node("AudioStreamPlayer2D") 
# Called when the node enters the scene tree for the first time.
@onready var player : CharacterBody2D = get_node("Player")

func _ready():
	pass # Replace with function body.
	#bgmusic.loop = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bgmusic.position = player.position
