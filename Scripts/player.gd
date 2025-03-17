class_name Player extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var camController : Node2D = get_parent()

@onready var ray_cast = $RayCast2D
@onready var ray_cast_2 = $RayCast2D2
@onready var collision_shape_2d = $CollisionShape2D

@onready var start_collision_shape_height = collision_shape_2d.shape.size.y

const SPEED : float = 100
const JUMP_VELOCITY : float = -300.0

var is_on_player : bool = false
var is_crouching : bool = false

# Dette styrer spiller-to relaterede ting. De to inputs er navne på actions, der senere i koden kobles til bevægelse. Skal kunne ændres til piletaster for debug spiller 2.
var player2 : bool = false
var leftKey : String = "Left"
var rightKey : String = "Right"
var jumpKey : String = "Jump"
var crouchKey : String = "Crouch"


func set_as_player_two() -> void:
	player2 = true
	leftKey = "2Left"
	rightKey = "2Right"
	jumpKey = "2Jump"
	crouchKey = "2Crouch"


func velocityPositionReset() -> void:
	velocity.x = 0


func _physics_process(delta) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	is_on_player = false
	
	# Superjump kode
	if ray_cast_2.is_colliding() && ray_cast_2.get_collider().is_in_group("players"):
		var collider = ray_cast_2.get_collider()
		is_on_player = true
		
		if collider.is_crouching:
			velocity.y = JUMP_VELOCITY*1.5
	elif ray_cast.is_colliding() && ray_cast.get_collider().is_in_group("players"): # Sat ind i elif for optimization
		var collider = ray_cast.get_collider()
			
		if collider.is_in_group("players"):
			is_on_player = true
			
			if collider.is_crouching:
				velocity.y = JUMP_VELOCITY*1.5

			
	if Input.is_action_just_pressed(jumpKey) and !is_crouching:
		if is_on_floor() and !is_on_player:
			velocity.y = JUMP_VELOCITY
			
	var direction : float = Input.get_axis(leftKey, rightKey)
	
	if direction:
		print(position.x)
		animation.play("Running")
		
		if direction > 0:
			velocity.x = SPEED
			
		elif direction < 0:
			velocity.x = -SPEED - Gamespeed.speed
			
		else:
			velocityPositionReset()
			
	else:
		animation.play("Idle")
		velocityPositionReset()
		
	
	if direction<0:
		animation.flip_h=true
		
	else:
		animation.flip_h = false
		
	if Input.is_action_pressed(crouchKey):
		is_crouching = true
		velocity.x =  -Gamespeed.speed
		animation.play("Crouching")
		collision_shape_2d.shape.size.y = start_collision_shape_height-5
		
	if Input.is_action_just_released(crouchKey):  #ineffektiv kode skal være on release istedet
		is_crouching = false
		collision_shape_2d.shape.size.y = start_collision_shape_height

	move_and_slide()
