extends KinematicBody2D

var is_moving_left = true

var gravity =  10 # check https://www.youtube.com/watch?v=jQKxOEbbirA for more detail
var velocity = Vector2(0, 0)
var life = 100
var speed = -50 # pixels per second


func _ready():
	$AnimatedSprite.play("Walk")

func _process(_delta):
	if(life <= 0):
		queue_free()
	move_character()
	detect_turn_around()
		
func move_character():
	velocity.x = -speed if is_moving_left else speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if not $FloorDetectorLeft.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x

func hit():
	$AttackDetector.monitoring = true

func end_of_hit():
	$AttackDetector.monitoring = false
	
func start_walk():
	$AnimatedSprite.play("Walk")

func _on_PlayerDetector_body_entered(body):
	$AnimatedSprite.play("Attack")

func _on_AttackDetector_body_entered(body):
	print(body)
	var tomou = false
	if get_slide_count() >0:
		for i in(get_slide_count()):
			if ("Player" in get_slide_collision(i).collider.name && tomou == false):
				get_slide_collision(i).life = get_slide_collision(i).life - 20
				tomou = true
				yield(get_tree().create_timer(1),"timeout")
				tomou = false


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword"):
		life = life -50
	pass # Replace with function body.
