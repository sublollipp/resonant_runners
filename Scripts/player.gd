class_name Player extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var camController : Node2D = get_parent()

const SPEED : float = 100
const JUMP_VELOCITY : float = -300.0

# Dette styrer spiller-to relaterede ting. De to inputs er navne på actions, der senere i koden kobles til bevægelse. Skal kunne ændres til piletaster for debug spiller 2.
var player2 : bool = false
var leftKey : String = "Left"
var rightKey : String = "Right"
var jumpKey : String = "Jump"

func set_as_player_two() -> void:
	player2 = true
	leftKey = "2Left"
	rightKey = "2Right"
	jumpKey = "2Jump"
	
func velocityPositionReset() -> void:
	velocity.x = 0

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed(jumpKey) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
		
	move_and_slide()
