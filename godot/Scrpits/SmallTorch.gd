extends Area2D
@export var state = "On"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	var state = "On"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimationPlayer.play(state)


func _on_area_entered(area):
	if area.is_in_group("enemies"):
		state = "Off"
		$AnimationPlayer.play("Off")
		$SmallTourch/PointLight2D.enabled = false
		$SmallTourch/PointLight2D/Alo.visible = false
		$CollisionShape2D.disabled = true


func _on_body_entered(body):
	if body.is_in_group("Player"):
		state = "Off"
		$AnimationPlayer.play("Off")
		$SmallTourch/PointLight2D.enabled = false
		$SmallTourch/PointLight2D/Alo.visible = false
		$CollisionShape2D.disabled = true
		body.increment_light_scale(Vector2(0.2, 0.2))

		
		
