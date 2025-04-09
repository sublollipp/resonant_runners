extends Node2D

func openDoor() -> void:
	$Polygon2D.hide()
	$StaticBody2D.queue_free()
