extends Node

@onready var bridge : LaserBridge = get_parent()

func _ready() -> void:
	bridge.savedPoints = bridge.points.duplicate()
	print(str(bridge.savedPoints))
	bridge.inEditor = false
	print(str(bridge.savedPoints))
	bridge.get_node("EndPoint").position = bridge.savedPoints.get(1)
	bridge.get_node("StartPoint").position = bridge.savedPoints.get(0)
	bridge.points[1] = bridge.points.duplicate().get(0)
	var newShape = bridge.get_node("StaticBody2D").get_node("CollisionShape2D").shape.duplicate()
	newShape.b = bridge.points[1]
	newShape.a = bridge.points[1]
	bridge.get_node("StaticBody2D").get_node("CollisionShape2D").shape = newShape
