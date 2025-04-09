extends Node2D

func openDoor() -> void:
	$Polygon2D.hide()
	if $StaticBody2D and is_instance_valid($StaticBody2D):
		$StaticBody2D.queue_free()
