extends CharacterBody2D

var speed = 50.0
var live = 30
@onready var player : CharacterBody2D = get_node("../../Player")
@onready var Explode : AnimationPlayer = get_node("EnemyExplode/AnimationPlayer")
var state : String = "Non"
var state_machine
@export var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$DeathLampRise.visible = true
	$DeathLampWalk.visible = false
	$DeathLamp/CollisionShape2D.disabled = true
	$CollisionShape2D2Walk.disabled = true
	$EnemyExplode.visible = false
	
	state_machine = $AnimationTree.get('parameters/playback')
	
	direction = (player.global_position - global_position).normalized()

	if direction.x > 0:
		get_node( "DeathLampRise" ).set_flip_h( false )
		get_node( "DeathLampWalk" ).set_flip_h( false )
	else:
		get_node( "DeathLampRise" ).set_flip_h( true )
		get_node( "DeathLampWalk" ).set_flip_h( true )
	state_machine.travel('Rise')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if live <= 0:
		death()
	else:
		if state == "Ready":
			state_machine.travel('Walk')
			if direction.x > 0:
				position += transform.x * speed * delta
			else:
				position -= transform.x * speed * delta
		
func ready():
	state = "Ready"
		
func death():
	state_machine.travel('Death')
	Explode.play("Explode")
