@tool
class_name ColorGate extends Line2D

var lineColor : Color = Color.WHITE

func _ready() -> void:
	var colShape = CollisionShape2D.new()
	var shape = SegmentShape2D.new()
	shape.a = points[0]
	shape.b = points[1]
	colShape.shape = shape
	get_child(0).add_child(colShape)
	
	if color == "Orange":
		$StaticBody2D.set_collision_layer_value(6, true)
	if color == "Cyan":
		$StaticBody2D.set_collision_layer_value(7, true)
		

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
			print("Reset")
			if pairedPortal.pairedPortal == self:
				var tempPort = pairedPortal
				pairedPortal = newPaired
				tempPort.pairedPortal = newPaired
			else:
				pairedPortal = newPaired
		elif newPaired.pairedPortal != self:
			print("eliffen kørte")
			pairedPortal = newPaired
			newPaired.color = color
			newPaired.pairedPortal = self
		else:
			pairedPortal = newPaired
