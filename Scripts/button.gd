class_name rrButton extends Node2D

signal buttonPressed

var pressed : bool = false

var playersOnButton : int = 0

@export var frame = 0:
	set(nf):
		frame = nf
		$AnimatedSprite2D.frame = frame + addedFrames

var addedFrames = 4:
	set(nf):
		addedFrames = nf
		$AnimatedSprite2D.frame = frame + nf

@export var connectedNodes : Array[Node2D] = []

@export_enum("White", "Cyan", "Orange") var color = "White"

func _ready() -> void:
	var material : ShaderMaterial = $AnimatedSprite2D.material as ShaderMaterial
	if color == "Cyan":
		addedFrames = 0
		$Area2D.set_collision_layer_value(7, false)
		material.set_shader_parameter("target_color", Color.CYAN)
	if color == "Orange":
		addedFrames = 2
		$Area2D.set_collision_layer_value(6, false)
		material.set_shader_parameter("target_color", Color.ORANGE)


func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("knapned")
	playersOnButton += 1
	pressed = true
	buttonPressed.emit()

func _on_area_2d_body_exited(body: Node2D) -> void:
	playersOnButton -= 1
	if playersOnButton == 0:
		pressed = false
		$AnimationPlayer.play("knaptryk")
