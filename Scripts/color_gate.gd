@tool
class_name ColorGate extends Line2D

var lineColor : Color = Color.CYAN

func _ready() -> void:
	var colShape : CollisionShape2D = $Area2D/CollisionShape2D
	colShape.shape.a = points[0]
	colShape.shape.b = points[1]
	print(name, " punkt 1 er grafisk (", points[0], ", ", points[1], " collision er (", colShape.shape.a, ", ", colShape.shape.b, ")")

@export_enum("Cyan", "Orange") var color = "Cyan":
	set(newColor):
		color = newColor
		default_color = newColor
		if pairedPortal is ColorGate:
			if pairedPortal.color != newColor:
				pairedPortal.color = newColor
		if newColor == "Cyan":
			lineColor = Color.CYAN
		else:
			lineColor = Color.ORANGE

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
