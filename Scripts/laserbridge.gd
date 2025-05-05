@tool
class_name LaserBridge extends Line2D

var lastPoints : PackedVector2Array = points
var savedPoints : PackedVector2Array = points

var inEditor : bool = true
@export var keepUpdating : bool = false

@onready var colShape : SegmentShape2D = $StaticBody2D/CollisionShape2D.shape

@export var speed : float = 1
@export var lerpMaster2000 : float = 0

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func makeBridge() -> void:
	keepUpdating = true
	# print("JEG LAVER EN BROOOO")
	if lerpMaster2000 > 0: return
	$AnimationPlayer.play("openBridge", -1, speed)

func _process(delta: float) -> void:
	if inEditor:
		if points != lastPoints:
			lastPoints = points.duplicate()
			if points.size() >= 2:
				$StartPoint.position = points.get(0)
				$EndPoint.position = points.get(1)
	else:
		if savedPoints.size() >= 2:
			points[1] = lerp(points.get(0), savedPoints.get(1), lerpMaster2000)
func _physics_process(delta: float) -> void:
	if !inEditor && keepUpdating:
		colShape = $StaticBody2D/CollisionShape2D.shape as SegmentShape2D
		var new_shape = colShape.duplicate()
		new_shape.a = points.get(0)
		new_shape.b = points.get(1)
		$StaticBody2D/CollisionShape2D.shape = new_shape
