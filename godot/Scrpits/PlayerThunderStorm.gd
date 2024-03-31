extends Node2D

const OBJECT = preload("../Objects/Efects/PlayerThunder.tscn")
const TOTAL_OBJECTS = 3
var objects = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	instance_object()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if objects <= TOTAL_OBJECTS:
		var RunObject = randi() % 50
		if RunObject == 1:
			instance_object()
			objects += 1
	else:
		queue_free()


func instance_object():
	var main = get_tree().current_scene
	var offset_position = randi() % 500
	var rng = RandomNumberGenerator.new()
	offset_position = rng.randf_range(-100.0, 100.0)
	# Instatnce new enmies and Drop enemies
	var ObjectDrop = OBJECT.instantiate()
	ObjectDrop.global_position = Vector2(global_position.x - offset_position, global_position.y - 40)
	main.add_child(ObjectDrop)


