extends Control






func _on_AnimatedSprite_ready():
	$AnimatedSprite/AudioStreamPlayer2D.play()
	pass # Replace with function body.


func _on_AnimatedSprite_tree_entered():
	$AnimatedSprite.play("rocha")
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.visible = false 
	$ColorRect/AnimationPlayer.play("transiçao")
	pass # Replace with function body.
