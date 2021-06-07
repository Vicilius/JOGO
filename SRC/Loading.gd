extends Control

var aceitar = Input.get_action_strength("accept")

var click = 0

export var next_scene = ""
var load_time = 2
onready var tween = $Tween




func _ready():
	$ColorRect/AnimationPlayer.play("aparecer")
	aceitar = false
	$Continuar.visible = false
	
	
	tween.interpolate_property($LoadingBar, "value", 0,100, load_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _on_Tween_tween_all_completed():
	
	aceitar = true
	$Continuar.visible = true
	$LoadingBar.visible = false
	

	
func _physics_process(delta):
	
		if Input.get_action_strength("accept"):
			if next_scene != null:
				get_tree().change_scene(next_scene)



