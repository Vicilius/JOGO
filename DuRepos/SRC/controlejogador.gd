class_name Jogador1
extends "res://SRC/Actors/Actor.gd"

signal killed()

var MAX_SPEED = 700
const GRAVITY = 50
const Walk_speed = 300
const Dash_speed = 600
const Crouch_speed = 100
const CHAIN_PULL = 105
const Max_life = 100

onready var crouching_collision = $CollisionCrouch
onready var walk_collision = $CollisionShape2D
onready var head = $RayTop
onready var health = Max_life setget _set_health
onready var Invunerability = $Invencivel

var is_crouched = false
var is_up 
var pos = Vector2.ZERO
var newton = gravity
var wallSlide = 50
var isAttacking = false
var Katana = 2
const FIRE = preload("res://SRC/Bullet.tscn")
onready var sprite = $Sprite
onready var gun = sprite.get_node(@"Gun")
var balas = 6
var can_shoot = true
var head_bonked = false


const JUMPFORCE = 1000
const WALL_SLIDE_ACCELERATION = 10
const MAX_WALL_SLIDE_SPEED = 120
var onWall = false





func _physics_process(delta):
	if(life <= 0):
		queue_free()
	var direction = get_direction()
	var friction = false
	
	if head.is_colliding():
		head_bonked = true
	
	
	if Input.get_action_strength("MoveRight"):
		pos.x = MAX_SPEED
		if is_crouched:
			$AnimatedSprite.play("movimentoagachado")
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.play("movimento")
			$AnimatedSprite.flip_h = true
	elif Input.get_action_strength("MoveLeft"):
		pos.x = -MAX_SPEED
		if is_crouched:
			$AnimatedSprite.play("movimentoagachado")
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.play("movimento")
			$AnimatedSprite.flip_h = false
	else:
		friction = true
	if Input.is_action_pressed("crouch"):
		crouch()
	if Input.is_action_just_released("crouch"):
		is_crouched = false
		stand()
	
	
	
	if friction == true:
		velocity.x = 0
		$AnimatedSprite.play("idle")

	pos.y = pos.y + newton
	
	if Input.is_action_just_pressed("Melee") && Katana == 2:
		$ResetAttack.start()
		$AnimatedSprite.play("ataque")
		isAttacking = true
		Katana = Katana - 1
		$AttackArea/CollisionShape2D.disabled = false
		$AttackArea/CollisionShape2D2.disabled = false
	elif Input.is_action_just_pressed("Melee") && Katana == 1:
		$ResetAttack.start()
		$AnimatedSprite.play("ataque2")
		isAttacking = true
		Katana = Katana - 1
		$AttackArea/CollisionShape2D.disabled = false
		$AttackArea/CollisionShape2D2.disabled = false
		
		
	if direction.x != 0:
		sprite.scale.x = 1 if direction.x > 0 else -1
	var is_shooting = false
	if Input.is_action_just_pressed("Shoot"):
		if isAttacking == false && can_shoot == true:
			if(balas > 0):
				can_shoot = false
				balas = balas -1
				is_shooting = gun.shoot(sprite.scale.x)
				yield(get_tree().create_timer(1),"timeout")
				can_shoot = true

	if Input.is_action_just_pressed("dash"):
		dash()
		$AnimatedSprite.play("dash")
		
		
	if MAX_SPEED == Dash_speed and friction == false:
		$AnimatedSprite.play("dash")
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		$AnimatedSprite.play("jump")
		pos.y -= JUMPFORCE
		onWall = false
		
	if not is_on_floor():
		$AnimatedSprite.play("jump")
	elif not is_on_floor() and MAX_SPEED == Dash_speed:
		$AnimatedSprite.play("dash")
	if is_on_wall():
		Input.is_action_just_pressed("Jump")
		$AnimatedSprite.play("wall")
	
	
	pos = move_and_slide(pos,Vector2.UP)
	
	pos.x = lerp(pos.x,0,0.2)
	
	
	if onWall == true:
		
		if Input.is_action_just_pressed("Jump") && onWall == true:
		 
			pos.y = - JUMPFORCE
			onWall = false
			if is_on_wall():
				var vira = 1
				if $AnimatedSprite.flip_h == false:
					vira = -1
				else:
					vira = 1
				pos.x = JUMPFORCE * vira
				#onWall = false
	if is_on_wall() && !is_on_floor():
		newton = wallSlide
		pos.y = - JUMPFORCE
		#onWall == true
		$AnimatedSprite.play("wall")
		if pos.y > 0:
			$Slide.play("default")
		if pos.y < 0 && !Input.is_action_just_pressed("Jump"):

			pos.y = 0
		#$AnimatedSprite.flip_h = x > 0
		newton = wallSlide
		pos.y += newton * delta
		
		#print ("test")
	else:
		$Slide.play("null")
		newton = GRAVITY
	if is_on_floor()|| is_on_wall():
		onWall = true
	
	if Invunerability.time_left != 0:
		$AnimatedSprite.play("tomou")

#	if get_slide_count() >0 : 
#		for i in(get_slide_count()):
#			if ("Enemy" in get_slide_collision(i).collider.name && tomou == false) :
#				life = life - 20
#				tomou = true
#				$AnimatedSprite.play("tomou")
#				yield(get_tree().create_timer(1),"timeout")
#				tomou = false



func dash():
	MAX_SPEED = Dash_speed
	pass

	$Timer.start()	


func _on_Timer_timeout():
	MAX_SPEED = Walk_speed
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	#seta a variavel de ataque para falso e impede que o personagem ataque sem o comando
	if $AnimatedSprite.animation == "ataque":
		isAttacking = false
	$AttackArea/CollisionShape2D.disabled = true
	$AttackArea/CollisionShape2D2.disabled = true
	
	if $AnimatedSprite.animation == "ataque2":
		isAttacking = false
	$AttackArea/CollisionShape2D.disabled = true
	
	#animação e repor ataques da katana
	if $AnimatedSprite.animation == "ataque":
		$AnimatedSprite.play("idle")
	if $AnimatedSprite.animation == "ataque2":
		$AnimatedSprite.play("idle")
		Katana = 2
	pass # Replace with function body.


func _on_ResetAttack_timeout():
	Katana = 2
	pass # Replace with function body.


func get_direction():
	return Vector2(
		Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft"),
		-1 if is_on_floor() and Input.is_action_just_pressed("pular") else 0
	)

func crouch():
	is_crouched = true
	crouching_collision.disabled = false
	walk_collision.disabled = true
	MAX_SPEED = Crouch_speed
func stand():
	if head_bonked == false && is_crouched == false:
		is_crouched = false
		crouching_collision.disabled = true
		walk_collision.disabled = false
		MAX_SPEED = Walk_speed

func damage(amount):
	if Invunerability.is_stopped():
		Invunerability.start()
		_set_health(health - amount)
		

func kill():
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0 , Max_life)
	if health != prev_health:
		emit_signal("health_updated",health)
		if health ==0:
			kill()
			emit_signal("killed")


func _on_HitBox_area_entered(area):
	if area.is_in_group("Enemy"):
		damage(20)
	pass # Replace with function body.
