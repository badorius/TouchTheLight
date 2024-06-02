extends CharacterBody2D

var speed = 50.0
var live = 10
@onready var player : CharacterBody2D = get_node("../Player")
const DamageIndicator = preload("res://Objects/Efects/damage_indicator.tscn")
const PointsIndicator = preload("res://Objects/Efects/points_indicator.tscn")
@export var pointsvalue : int = 50
@export var ArrowDamage_sound : AudioStreamPlayer2D
var state : String = "Non"
var state_machine
@export var direction : Vector2
@export var Toxic : bool = false
@export var Ice : bool = false
var FreqToxic : float = 10.0
var FreqCounter : float = 0
@export var score_value : int = 10
const MaxDistPlayer : int = 350

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const BootsItemDrop = preload("../Objects/Items/BootsItemDrop.tscn")
const ArrowItemDrop = preload("../Objects/Items/ArrowItemDrop.tscn")
const CoatItemDrop = preload("../Objects/Items/CoatItemDrop.tscn")
const LivePotionDrop = preload("../Objects/Items/LivePotionDrop.tscn")
const ManaPotionDrop = preload("../Objects/Items/ManaPotionDrop.tscn")
const Magic1ItemDrop = preload("../Objects/Items/Magic1ItemDrop.tscn")
const Magic2ItemDrop = preload("../Objects/Items/Magic2ItemDrop.tscn")
const Magic3ItemDrop = preload("../Objects/Items/Magic3ItemDrop.tscn")
const Explode = preload("../Objects/Efects/EnemyExplode.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	ArrowDamage_sound = $ArrowDamage
	
	$DeathLamp/CollisionShape2D.disabled = true
	$DeathLampRise.visible = true
	$DeathLampWalk.visible = false
	$DeathLamp/CollisionShape2D.disabled = false
	$CollisionShape2D2Walk.disabled = false
	
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

	if Toxic == true:
		$ToxicLight2D.color = "199f00e5"
		$ToxicLight2D.visible = true
		if FreqCounter < FreqToxic:
			FreqCounter += 0.1
		else:
			FreqCounter = 0
			hurt(50)
			
	if Ice == true:
		$IceLight2D.visible = true
		
	if abs(global_position.x - player.global_position.x) > MaxDistPlayer:
		queue_free()
		
	if live <= 0 and state != "Death":
		death()
	elif state != "Death":
		if state == "Ready":
			$DeathLamp/CollisionShape2D.disabled = false
			state_machine.travel('Walk')
			if direction.x > 0:
				position += transform.x * speed * delta
			else:
				position -= transform.x * speed * delta
				
	# Add the gravity PENDING TO FIX
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
		
func ready():
	state = "Ready"

func explode():
		var main = get_tree().current_scene
		var A = Explode.instantiate()
		A.global_position = global_position
		main.add_child(A)

func death():
	#FIX Random size
	var offset_position = randi() % 20
	var main = get_tree().current_scene
	var D = PointsIndicator.instantiate()
	var color = "white"
	D.global_position = Vector2(global_position.x - offset_position, (global_position.y) - offset_position)
	D.show_points(pointsvalue, color)
	main.add_child(D)
		
	state = "Death"
	state_machine.travel('Death')
	$DeathLampWalk.visible = false
	explode()
	player.add_score(pointsvalue)
	drop_item()
	
func hurt(damage):
		if live <= 0 and state != "Death":
			death()
		
		else:
			ArrowDamage_sound.play()
			live -= damage
			#ProgressBar3.value = live
			

func decrease_speed(value):
	if speed < 0:
		speed = 0
	else:
		speed -= value
	
func toxic():
	Toxic = true

func ice():
	Ice = true
	
func drop_item():
		var main = get_tree().current_scene
		var rnd = randi() % 8
		match rnd:
			0:
				var A = BootsItemDrop.instantiate()
				A.global_position = global_position
				if direction.x == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y + 15
				main.add_child(A)
			1:
				var A = ArrowItemDrop.instantiate()
				A.global_position = global_position
				if direction.x == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y + 15
				main.add_child(A)
			2:
				var A = CoatItemDrop.instantiate()
				A.global_position = global_position
				if direction.x == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y + 15
				main.add_child(A)
			3:
				var A = LivePotionDrop.instantiate()
				A.global_position = global_position
				if direction.x == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y + 15
				main.add_child(A)
				
			4:
				var A = ManaPotionDrop.instantiate()
				A.global_position = global_position
				if direction.x == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y + 15
				main.add_child(A)
				
			5:
				var A = Magic1ItemDrop.instantiate()
				A.global_position = global_position
				if direction.x == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y + 15
				main.add_child(A)
			6:
				var A = Magic2ItemDrop.instantiate()
				A.global_position = global_position
				if direction.x == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y + 15
				main.add_child(A)
			7:
				var A = Magic3ItemDrop.instantiate()
				A.global_position = global_position
				if direction.x == 1:
					A.position.x = global_position.x + 15
				else:
					A.position.x = global_position.x - 45
				A.position.y = global_position.y + 15
				main.add_child(A)
		
				

func _on_death_lamp_body_entered(body):
	var attack_power = randi() % 10
	if body.is_in_group("Player"):
		body.hurt(attack_power)
		live = 0
 # Replace with function body.
