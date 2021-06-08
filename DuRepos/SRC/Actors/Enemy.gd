class_name Enemy
extends "res://SRC/Actors/Actor.gd"


func _ready():
	velocity.x = -speed.x
	$AnimatedSprite.play("Idle")
	
	

func _physics_process(delta):
	if is_on_wall():
		velocity.x *= -1.0
	velocity.y = move_and_slide(velocity,FLOOR_NORMAL).y
