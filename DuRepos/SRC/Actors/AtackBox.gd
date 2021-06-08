extends Area2D


func _on_body_enter(body):
	if body is Enemy:
		body.queue_free()
		print("aa")
	pass


func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if body is Enemy:
		body.queue_free()
		print("aa")
	pass # Replace with function body.
