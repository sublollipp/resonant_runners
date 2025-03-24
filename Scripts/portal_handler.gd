extends Node

var inPortal : bool = false:
	set(newVal):
		print(player.name, " is now ", newVal, "ly in a portal")
		inPortal = newVal
var previousPortal : ColorGate = null

@onready var player : Player = get_parent()

func _on_character_body_2d_portal_touched(gateTouched : ColorGate) -> void:
	print("Gate Touched")


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(player.name, " rører en portal: ", body.name)
	if body.is_in_group("PortalCollider") && !inPortal:
		print("Spændende sager")
		var portal = body.get_parent() as ColorGate
		inPortal = true
		previousPortal = portal
		player.global_position = (portal.pairedPortal.global_position + portal.pairedPortal.points[0] + (portal.pairedPortal.points[1] - portal.pairedPortal.points[0]) / 2)
		print(portal.pairedPortal.global_position + portal.pairedPortal.points[0] + (portal.pairedPortal.points[1] - portal.pairedPortal.points[0]) / 2)



func _on_area_2d_body_exited(body: Node2D) -> void:
	print("EXITEDddddddddddd")
	if previousPortal && inPortal:
		if body.is_in_group("PortalCollider"):
			var portal : ColorGate = body.get_parent()
			if portal.pairedPortal == previousPortal:
				inPortal = false
