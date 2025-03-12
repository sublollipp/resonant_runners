extends Node2D

func _physics_process(delta: float) -> void:
	$CamController.position.x += 100 * delta;
