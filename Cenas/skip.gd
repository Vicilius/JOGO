extends Label




var click = 0




# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		click += 1
		
		
		
		if click == 1 :
			get_tree().change_scene("res://Cenas/Nivel/MenuGame.tscn")





# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
