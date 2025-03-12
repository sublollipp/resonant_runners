extends Node2D

@onready var speed = Gamespeed.speed;

func _process(delta: float) -> void:
	$CamController.position.x += speed * delta
