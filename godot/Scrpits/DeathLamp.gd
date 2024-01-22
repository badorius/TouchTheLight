extends CharacterBody2D

var speed = 50.0
var live = 30
@onready var player : CharacterBody2D = get_node("../../Player")
@onready var Explode : AnimationPlayer = get_node("EnemyExplode/AnimationPlayer")
const DamageIndicator = preload("res://Objects/damage_indicator.tscn")
@export var ArrowDamage_sound : AudioStreamPlayer2D
var state : String = "Non"
var state_machine
@export var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	ArrowDamage_sound = $ArrowDamage
	$DeathLampRise.visible = true
	$DeathLampWalk.visible = false
	$DeathLamp/CollisionShape2D.disabled = false
	$CollisionShape2D2Walk.disabled = false
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
	
func hurt(damage):
		if live <= 0 and state != "Death":
			death()
		
		else:
			ArrowDamage_sound.play()
			live -= damage
			#ProgressBar3.value = live
			
			#FIX Random size
			var offset_position = randi() % 20
			var main = get_tree().current_scene
			var D = DamageIndicator.instantiate()
			var color = "yellow"
			D.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
			D.show_damage(damage, color)
			main.add_child(D)


func _on_death_lamp_body_entered(body):
	var attack_power = randi() % 10
	if body.is_in_group("Player"):
		body.hurt(attack_power)
		live = 0
 # Replace with function body.
