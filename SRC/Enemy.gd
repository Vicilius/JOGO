class_name Enemy
extends "res://SRC//Actor.gd"

var dead = false
onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite



func _ready():
	velocity.x = speed.x
	$AnimatedSprite.play("Idle")
	
	

func _physics_process(delta):
	if(life <= 0):
		queue_free()
#	if is_on_wall():
#		velocity.x *= -1.0
#	velocity.y = move_and_slide(velocity,FLOOR_NORMAL).y
	if not floor_detector_left.is_colliding():
		velocity.x = speed.x
	elif not floor_detector_right.is_colliding():
		velocity.x = -speed.x
	if is_on_wall():
		velocity.x *= -1
	# We only update the y value of _velocity as we want to handle the horizontal movement ourselves.
	velocity.y = move_and_slide(velocity, FLOOR_NORMAL).y
	# We flip the Sprite depending on which way the enemy is moving.
	sprite.scale.x = 1 if velocity.x > 0 else -1
	
	if get_slide_count() >0:
		for i in(get_slide_count()):
			if "Player" in get_slide_collision(i).collider.name:
				get_slide_collision(i).life = get_slide_collision(i).life - 20
	
	


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword"):
		life = life -50
		print (life)
#	elif area.is_in_group("bullet"):
#		dead = true
#
#		queue_free()
#
#
	if area.is_in_group("Player"):
		area.life = area.life -50
		print (area.life)
	
	if(area.get_collision_layer_bit(4)):
		life = life - 50
		
	pass # Replace with function body.
	
	
