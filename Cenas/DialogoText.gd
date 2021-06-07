extends Control


var dialogPath = "res://SRC/DialogoJsons/Dialog0.json"
export(float) var textSpeed = 0.05

var dialog
export var TextNum = 0
var phraseNum = 0
var finished = false



# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()
	
	
		

func _process(delta):
	$TextureRect/NinePatchRect.visible = finished
	
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			$TextureRect/Texto.visible_characters = len($TextureRect/Texto.text)
			
	if Input.is_action_just_pressed("accept"):
		if finished:
			nextPhrase()
		else:
			$TextureRect/Texto.visible_characters = len($TextureRect/Texto.text)
	
		

func getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(dialogPath), "File Path does not exist")
	
	f.open(dialogPath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []

func nextPhrase() -> void:
	if phraseNum >= len(dialog[TextNum]):
		queue_free()
		#TextNum += 1 
		return
		
	finished = false
	
	
	$TextureRect/Texto.text = dialog[TextNum][phraseNum]["Text"]
	
	
	$TextureRect/Texto.visible_characters = 0
	
	
	
	
	
	
	
	while $TextureRect/Texto.visible_characters < len($TextureRect/Texto.text):
		$TextureRect/Texto.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
	
	finished = true
	phraseNum += 1
	return
	
	

