extends Node2D

func _ready() -> void:
	GDSync.expose_func(dontUseThisFunction)

func dontUseThisFunction() -> void:
	queue_free()

func openDoor() -> void:
	GDSync.call_func(dontUseThisFunction)
	#$Polygon2D.hide()
	#if $StaticBody2D and is_instance_valid($StaticBody2D):
	#	$StaticBody2D.queue_free()
