extends Node2D

@onready var bgmusic : AudioStreamPlayer2D = get_node("AudioStreamPlayer2D") 
# Called when the node enters the scene tree for the first time.
@onready var player : CharacterBody2D = get_node("Player")
const FlayingEye = preload("../Objects/Enemies/FlayingEye.tscn")
const Rock = preload("../Objects/WorldObjects/Rock.tscn")
const Skeleton = preload("../Objects/Enemies/skeleton.tscn")
const NightBorne = preload("../Objects/Enemies/NightBorne.tscn")
const DeathLamp = preload("../Objects/Enemies/death_lamp.tscn")
var RangeXEnemiesMin : float = 200.0
var RangeXEnemiesMax : float = 3200.0
var RangeYEnemies : float = 209.0
@export var EnemyCounterDrop : float = 0.0


func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if player.global_position.x >= RangeXEnemiesMin and player.global_position.x <= RangeXEnemiesMax and EnemyCounterDrop >= 30:
		drop_enemy()
		EnemyCounterDrop = 0.0
	else:
		EnemyCounterDrop += 0.1
		
		
	bgmusic.position = player.position
	
	
func drop_enemy():
	var main = get_tree().current_scene
	#Random enemy
	var EnemyRnd = randi() % 1
	var offset_position = randi() % 300
	var EnemyDirection = randi() % 2
	var direction = (player.global_position - global_position).normalized()
	# Instatnce new enmies and Drop enemies
	
	match EnemyRnd:
		0:
			var EnemyDrop = DeathLamp.instantiate()
			if EnemyDirection >= 1:
				EnemyDrop.global_position = Vector2(player.global_position.x  + offset_position , RangeYEnemies)

			else:
				EnemyDrop.global_position = Vector2(player.global_position.x - offset_position , RangeYEnemies)

			main.add_child(EnemyDrop)
		1:
			var EnemyDrop = Skeleton.instantiate()
			if direction.x > 1:
				EnemyDrop.global_position = Vector2(player.global_position.x*2  - offset_position , (player.global_position.y))
			else:
				EnemyDrop.global_position = Vector2(player.global_position.x/2  - offset_position , (player.global_position.y))
			main.add_child(EnemyDrop)
		2:
			var EnemyDrop = NightBorne.instantiate()
			if direction.x > 1:
				EnemyDrop.global_position = Vector2(player.global_position.x*2  - offset_position , (player.global_position.y))
			else:
				EnemyDrop.global_position = Vector2(player.global_position.x/2  - offset_position , (player.global_position.y))
			main.add_child(EnemyDrop)	
		3:
			var EnemyDrop = FlayingEye.instantiate()
			if direction.x > 1:
				EnemyDrop.global_position = Vector2(player.global_position.x*2  - offset_position , (player.global_position.y))
			else:
				EnemyDrop.global_position = Vector2(player.global_position.x/2  - offset_position , (player.global_position.y))
			main.add_child(EnemyDrop)
