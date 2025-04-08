class_name Player extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var camController : Node2D = get_parent()

@onready var ray_cast = $RayCast2D
@onready var ray_cast_2 = $RayCast2D2
@onready var collision_shape_2d = $CollisionShape2D

@onready var start_collision_shape_height = collision_shape_2d.shape.size.y

var color = "Cyan"

const SPEED : float = 100
const ACCELERATION : float = 50
const JUMP_VELOCITY : float = -300.0

var is_on_player : bool = false
var is_crouching : bool = false
var is_jumping : bool = false

signal portalTouched

# Dette styrer spiller-to relaterede ting. De to inputs er navne på actions, der senere i koden kobles til bevægelse. Skal kunne ændres til piletaster for debug spiller 2.
var player2 : bool = false
var leftKey : String = "Left"
var rightKey : String = "Right"
var jumpKey : String = "Jump"
var crouchKey : String = "Crouch"

func set_as_player_two() -> void:
	player2 = true
	set_collision_mask_value(6, false)
	set_collision_mask_value(7, true)
	color = "Orange"
	leftKey = "2Left"
	rightKey = "2Right"
	jumpKey = "2Jump"
	crouchKey = "2Crouch"

func velocityPositionReset() -> void:
	velocity.x = 0


func _physics_process(delta) -> void:
	is_on_player = false
	
	
	if not is_on_floor(): #start hop skal in
		velocity += get_gravity() * delta
	else:
		is_jumping = false
	
	if is_crouching:
		velocity.x = -Gamespeed.speed
	
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
			
	var direction : float = Input.get_axis(leftKey, rightKey)
	if !is_crouching:
		if direction:
			if !is_jumping:
				animation.play("Running"+color)
				animation.sprite_frames.set_animation_speed("Running"+color, 14)
			
			if direction > 0:
				#SPEED (er desiret speed i løb, velocetyen er current speed, derfor hvis man trækker dem fra hindanden finder man forksellen og kan dermed tilføjde den istedet for at sætte
				if velocity.x < SPEED:
					if SPEED - velocity.x < ACCELERATION:
						velocity.x += ACCELERATION
					else:
						velocity.x += SPEED - velocity.x
			
			elif direction < 0:
				if velocity.x > -SPEED:
					if abs(-SPEED - velocity.x) > ACCELERATION:
					#velocity.x += -SPEED - Gamespeed.speed - velocity.x
						velocity.x -= ACCELERATION
					else:
						velocity.x += -SPEED - Gamespeed.speed - velocity.x
			
			else:
				# nedacceleration? on floor? (eller er det det andet else loop under) (JA DET ER BÆGGE ELSE STATEMENTS DER SKAL PÅRVIRKES
				if is_on_floor():
					velocityPositionReset()
				
		else:
			if !is_jumping:
				animation.play("Running"+color)
				animation.sprite_frames.set_animation_speed("Running"+color, 10)
				velocityPositionReset()
			
		if direction<0:
			animation.flip_h=true
			
		else:
			animation.flip_h = false
		
	if Input.is_action_just_pressed(crouchKey): #HVORFOR ER DER CROUCH LOGIK TO STEDER?!!!
		is_crouching = true
		animation.play("Crouching"+color)
		collision_shape_2d.shape.size.y = start_collision_shape_height-10
		
	if Input.is_action_just_released(crouchKey):  #ineffektiv kode skal være on release istedet
		is_crouching = false
		collision_shape_2d.shape.size.y = start_collision_shape_height
		animation.play("Running"+color)
		animation.sprite_frames.set_animation_speed("Running"+color, 6)
		
	if Input.is_action_just_pressed(jumpKey) and is_on_floor() and !is_on_player:
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		
	
	move_and_slide()
	$PortalHandler.checkIfInPortal()
