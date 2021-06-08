extends Actor

func _physics_process(delta: float) -> void:
	var direction: = Vector2(
		Input.get_action_strength("esquerda") - Input.get_action_strength("direita"),
		0.0
	)
	velocity = speed * direction
