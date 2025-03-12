extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var camController = get_parent()

const SPEED = 100
const JUMP_VELOCITY = -300.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		animation.play("Running")
		if direction > 0 && position.x < 750:
			velocity.x = SPEED
		if direction < 0 && position.x > 50:
			velocity.x = -SPEED - Gamespeed.speed
	else:
		animation.play("Idle")
		velocity.x = 0
	
	if direction<0:
		animation.flip_h=true
	else:
		animation.flip_h = false
		
	move_and_slide()
