class_name Player extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var camController : Node2D = get_parent()

@onready var ray_cast = $RayCast2D
@onready var ray_cast_2 = $RayCast2D2
@onready var collision_shape_2d = $CollisionShape2D

@onready var start_collision_shape_height = collision_shape_2d.shape.size.y





var color = "Cyan"

const SPEED : float = 100
var ACCELERATION : float = 50
var AIR_ACCELERATION : float = 10
const JUMP_VELOCITY : float = -310.0

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
var explosionColor : Color = Color(0, 255, 255, 255)

func _ready() -> void:
	$CPUParticles2D.color = explosionColor
	$CPUParticles2D.emission_colors[0] = explosionColor
	$CPUParticles2D.emission_colors[1] = explosionColor
	GDSync.expose_func(superjump)

func superjump() -> void:
	$CPUParticles2D.emitting = true
	velocity.y = JUMP_VELOCITY * 1.5

func set_as_player_two() -> void:
	player2 = true
	set_collision_mask_value(6, false)
	set_collision_mask_value(7, true)
	$StaticBody2D.set_collision_layer_value(7, false)
	$StaticBody2D.set_collision_layer_value(6, true)
	color = "Orange"
	explosionColor = Color(225,116,69,225)
	#leftKey = "2Left"
	#rightKey = "2Right"
	#jumpKey = "2Jump"
	#crouchKey = "2Crouch"

func velocityPositionReset() -> void:
	velocity.x = 0

func _physics_process(delta) -> void:
	if Gamespeed.speed > ACCELERATION:
		ACCELERATION = Gamespeed.speed
		AIR_ACCELERATION = ACCELERATION / 5
	if !GDSync.is_gdsync_owner(self): return
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
			superjump()
			GDSync.call_func(superjump)
			
	elif ray_cast.is_colliding() && ray_cast.get_collider().is_in_group("players"): # Sat ind i elif for optimization
		
		var collider = ray_cast.get_collider()
		is_on_player = true
		
		if collider.is_crouching:
			superjump()
			GDSync.call_func(superjump)
			
	var direction : float = Input.get_axis(leftKey, rightKey)
	
	if !is_crouching:
		if direction:
			var acc = AIR_ACCELERATION
			if is_on_floor():
				acc = ACCELERATION
			
			if !is_jumping:
				animation.play("Running"+color)
				animation.sprite_frames.set_animation_speed("Running"+color, 14)
			
			if direction > 0:
				#SPEED (er desiret speed i løb, velocetyen er current speed, derfor hvis man trækker dem fra hindanden finder man forksellen og kan dermed tilføjde den istedet for at sætte
				if velocity.x < SPEED:
					if abs(SPEED - velocity.x) > acc:
						velocity.x += acc
					else:
						velocity.x += SPEED - velocity.x
						
			
			elif direction < 0:
				if velocity.x > -SPEED:
					if abs(-SPEED - velocity.x) > acc:
					#velocity.x += -SPEED - Gamespeed.speed - velocity.x
						velocity.x -= acc
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
			if is_on_floor():
				velocityPositionReset()
			
		if direction<0:
			animation.flip_h=true
			
		else:
			animation.flip_h = false
		
	if Input.is_action_just_pressed(crouchKey):
		is_crouching = true
		animation.play("Crouching"+color)
		collision_shape_2d.shape.size.y = start_collision_shape_height-10
		
	if Input.is_action_just_released(crouchKey):
		is_crouching = false
		collision_shape_2d.shape.size.y = start_collision_shape_height
		animation.play("Running"+color)
		animation.sprite_frames.set_animation_speed("Running"+color, 6)
		
	if Input.is_action_just_pressed(jumpKey) and is_on_floor() and !is_on_player:
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		animation.play("Jumping"+color)
		
	move_and_slide()
	$PortalHandler.checkIfInPortal()
