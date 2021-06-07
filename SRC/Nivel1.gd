extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Dialogo_modal_closed():
	get_tree().change_scene("res://Cenas/Niveis/Nivel1_1.tscn")
	pass # Replace with function body.



