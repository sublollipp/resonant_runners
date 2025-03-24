@tool
class_name ColorGate extends Line2D

var lineColor : Color = Color.CYAN

func _ready() -> void:
	var colShape = CollisionShape2D.new()
	var shape = SegmentShape2D.new()
	shape.a = points[0]
	shape.b = points[1]
	colShape.shape = shape
	$Area2D.add_child(colShape)
	#$Area2D/CollisionShape2D.shape.a = points[0]
	#$Area2D/CollisionShape2D.shape.b = points[1]
	#print(name, " punkt 1 er grafisk (", points[0], ", ", points[1], " collision er (", $Area2D/CollisionShape2D.shape.a, ", ", $Area2D/CollisionShape2D.shape.b, ")")

@export_enum("White", "Cyan", "Orange") var color = "Cyan":
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Gået ind i noget")
