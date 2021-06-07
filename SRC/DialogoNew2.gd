extends Control


var dialogPath = "res://SRC/DialogoJsons/Dialog1_1.json"
export(float) var textSpeed = 0.05

var dialog
export var TextNum = 0
var phraseNum = 0
var finished = false



func _ready():
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()
	
	
		

func _process(delta):
	$NinePatchRect/AnimationPlayer.play("animado")
	$NinePatchRect.visible = finished
	
	
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			$TextureRect/Text.visible_characters = len($TextureRect/Text.text)
			
	if Input.is_action_just_pressed("accept"):
		if finished:
			nextPhrase()
		else:
			$TextureRect/Text.visible_characters = len($TextureRect/Text.text)
	
		

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
		return
		#TextNum += 1
	finished = false
	
	var f = File.new()
	var img = dialog[TextNum][phraseNum]["Emotion"] + ".png"
	if f.file_exists(img):
		$Portrait.texture = load(img)
	else: $Portrait.texture = $nada
	
	var b = File.new()
	var img2 = dialog[TextNum][phraseNum]["Background"] + ".png"
	if b.file_exists(img2):
		$Background.texture = load(img2)
	else: $Background.texture = $nada
	
	
	
	$TextureRect/Text.text = dialog[TextNum][phraseNum]["Text"]
	$TextureRect/Name.text = dialog[TextNum][phraseNum]["Name"]
	
	
	$TextureRect/Text.visible_characters = 0
	
	
	
	
	
	while $TextureRect/Text.visible_characters < len($TextureRect/Text.text):
		$TextureRect/Text.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
	
	finished = true
	phraseNum += 1
	return
	
	

