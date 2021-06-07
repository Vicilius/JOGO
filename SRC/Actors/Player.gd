extends Actor
#export (PackedScene) var Bullet

export(String) var action_suffix = ""
var can_shoot = true
var can_dash = true
var is_attacking = false
var balas = 6

#export var beam_duration = 1.5
#export var cooldown = 0.5
#var hit = null
onready var sprite = $Sprite
onready var gun = sprite.get_node(@"Gun")


func _ready():
#	$Line2D.remove_point(1)
	
	var camera: Camera2D = $Camera2D
	if action_suffix == "_p1":
		camera.custom_viewport = $"../.."
	elif action_suffix == "_p2":
		var viewport: Viewport = $"../../../../ViewportContainer2/Viewport"
		viewport.world_2d = ($"../.." as Viewport).world_2d
		camera.custom_viewport = viewport




func _process(delta):
	
	if(life <= 0):
		queue_free()
	
	var direction = get_direction()
	
	if Input.is_action_pressed("MoveRight") && is_attacking == false:
		if Input.is_action_pressed("MoveLeft"):
			$AnimatedSprite.play("idle")
		elif is_attacking == false:
			$AnimatedSprite.play("runRight")
			$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("MoveLeft") && is_attacking == false:
		if Input.is_action_pressed("MoveRight"):
			$AnimatedSprite.play("idle")
		elif is_attacking == false:
			$AnimatedSprite.play("runRight")
			$AnimatedSprite.flip_h = true
	elif is_attacking == false:
		$AnimatedSprite.stop()
		$AnimatedSprite.play("idle")
	if Input.is_action_just_pressed("Melee"):
		$AnimatedSprite.play("melee")
		$Sprite/Area2D/Atack.disabled = false
		is_attacking = true
		yield(get_tree().create_timer(0.5),"timeout")
		is_attacking = false
		$Sprite/Area2D/Atack.disabled = true
	if can_dash:
		if Input.is_action_just_pressed("DashLeft"):
			$AnimatedSprite.play("melee")
			move_and_slide(Vector2(2000,0),FLOOR_NORMAL)
			can_dash = false
			yield(get_tree().create_timer(1),"timeout")
			can_dash = true
		if Input.is_action_just_pressed("DashRight"):
			$AnimatedSprite.play("melee")
			move_and_slide(Vector2(-2000,0),FLOOR_NORMAL)
			can_dash = false
			yield(get_tree().create_timer(1),"timeout")
			can_dash = true
	if Input.is_action_pressed("Jump"):
		$AnimatedSprite.play("jump")
	var is_shooting = false
	
	if direction.x != 0:
		sprite.scale.x = 1 if direction.x > 0 else -1
		
	if Input.is_action_just_pressed("Shoot"):
		if is_attacking == false && can_shoot == true:
			if(balas > 0):
				can_shoot = false
				balas = balas -1
				is_shooting = gun.shoot(sprite.scale.x)
				yield(get_tree().create_timer(1),"timeout")
				can_shoot = true


func shoot():
	var projectile = load("res://SRC/Actors/Projectile.tscn")
	var bullet = projectile.instance() 
	add_child_below_node(get_tree().get_root().get_node("Player"),bullet)
	
	


func _physics_process(delta):
	var is_jumping_interrupted: = Input.is_action_just_released("Jump") and velocity.y < 0.0 
	var direction: = get_diraction()
	velocity = calculate_move_velocity(velocity,direction,speed, is_jumping_interrupted)
	velocity = move_and_slide(velocity,FLOOR_NORMAL)

	return

func get_diraction() -> Vector2:
	return Vector2(
		Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft"),
		-1.0 if Input.get_action_strength("Jump") and is_on_floor() else 0.0
	)
	
func calculate_move_velocity(lenear_velocity:Vector2,direction : Vector2,speed: Vector2, is_jumping_interrupted: bool) ->Vector2:
		var out = lenear_velocity
		out.x = speed.x *direction.x
		out.y += gravity * get_physics_process_delta_time()
		if direction.y ==-1.0:
			out.y = speed.y * direction.y
		if is_jumping_interrupted:
			out.y = 0.0
		return out
		
		

func get_direction():
	return Vector2(
		Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft"),
		-1 if is_on_floor() and Input.is_action_just_pressed("Jump") else 0
	)
