extends Node2D

func _ready() -> void:
	GDSync.expose_func(dontUseThisFunction)

func dontUseThisFunction() -> void:
	queue_free()

func openDoor() -> void:
	GDSync.call_func(dontUseThisFunction)
	dontUseThisFunction()
	
