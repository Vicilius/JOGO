class_name Gun
extends Position2D

const BULLET_VELOCITY = 1000.0
const Bullet = preload("res://teste/Bullet.tscn")




# This method is only called by Player.gd.
func shoot(direction = 1):
	var bullet = Bullet.instance()
	bullet.global_position = global_position
	bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0)
	bullet.set_as_toplevel(true)
	add_child(bullet)
	return true
