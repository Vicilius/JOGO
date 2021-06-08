extends Node2D

var velocity  = Vector2()


func _ready():
	yield(get_tree().create_timer(1),"timeout")
	queue_free()

func _physics_process(delta):
	move_local_x(500)
	print(position)
