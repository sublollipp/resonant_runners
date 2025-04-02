extends Node

var inPortal : bool = false:
	set(newVal):
		if newVal != inPortal:
			inPortal = newVal
var previousPortal : ColorGate = null

@onready var player : Player = get_parent()

func checkIfInPortal() -> void:
	if not get_parent().get_node("PortalArea").has_overlapping_bodies():
		inPortal = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("PortalCollider") && !inPortal:
		var portal = body.get_parent() as ColorGate
		inPortal = true
		previousPortal = portal
		player.global_position = (portal.pairedPortal.global_position + (portal.pairedPortal.points[0] + (portal.pairedPortal.points[1] - portal.pairedPortal.points[0]) / 2).rotated(portal.pairedPortal.rotation))
		print("Teleporterer spilleren til ",  (portal.pairedPortal.points[0] + (portal.pairedPortal.points[1] - portal.pairedPortal.points[0]) / 2).rotated(portal.pairedPortal.rotation))
		



func _on_area_2d_body_exited(body: Node2D) -> void:
	if previousPortal:
		if body.is_in_group("PortalCollider"):
			var portal : ColorGate = body.get_parent()
			if portal.pairedPortal == previousPortal:
				inPortal = false
