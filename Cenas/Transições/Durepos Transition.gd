extends CanvasLayer

signal transitioned

func _ready():
	transition()


func transition():
	$Control/ColorRect/AnimationPlayer.play("fade2")
