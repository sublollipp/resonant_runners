@tool

class_name ColorGate extends Line2D

@export var flipExitPortal : bool = false
@export var onetimeuse : bool = false

var used : bool = false:
	set(nv):
		if (onetimeuse):
			used = nv
		else:
			used = false

var lineColor : Color = Color.WHITE
var angle : float = 0 # Portalens vinkel med vandret
var flipOutput : bool = false

func _ready() -> void:
	if pairedPortal.onetimeuse:
		onetimeuse = true
	if (points[0].x == points[1].x):
		points[1].x += 0.1
	if (points[0].y == points[1].y):
		points[1].y += 0.1
	var colShape = CollisionShape2D.new()
	var shape = SegmentShape2D.new()
	shape.a = points[0]
	shape.b = points[1]
	colShape.shape = shape
	get_child(0).add_child(colShape)
	
	$StaticBody2D.set_collision_layer_value(8, false)
	
	if color == "Orange":
		$StaticBody2D.set_collision_layer_value(6, true)
	if color == "Cyan":
		$StaticBody2D.set_collision_layer_value(7, true)
	if color == "White":
		$StaticBody2D.set_collision_layer_value(8, true)
		

@export_enum("White", "Cyan", "Orange") var color = "White":
	set(newColor):
		color = newColor
		default_color = newColor
		if pairedPortal is ColorGate:
			if pairedPortal.color != newColor:
				pairedPortal.color = newColor
		if newColor == "Cyan":
			lineColor = Color.CYAN
		elif newColor == "Orange":
			lineColor = Color.ORANGE
		else:
			lineColor = Color.WHITE

@export var pairedPortal : ColorGate: ## Portalen, denne portal skal parres med
	set(newPaired):
		if newPaired is not ColorGate:
			if pairedPortal.pairedPortal == self:
				var tempPort = pairedPortal
				pairedPortal = newPaired
				tempPort.pairedPortal = newPaired
			else:
				pairedPortal = newPaired
		elif newPaired.pairedPortal != self:
			pairedPortal = newPaired
			newPaired.color = color
			newPaired.pairedPortal = self
		else:
			pairedPortal = newPaired
