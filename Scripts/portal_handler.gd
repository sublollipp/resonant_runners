extends Node

var inPortal : bool = false:
	set(newVal):
		if newVal != inPortal:
			inPortal = newVal
var previousPortal : ColorGate = null

@onready var player : Player = get_parent()
@onready var camController = player.get_parent()
@onready var rightLimit = camController.get_child(2)
@onready var rightLimitCollision = rightLimit.get_child(0)

@onready var portalArea : Area2D = $"../PortalArea"


func _ready():
	if player.color == "Cyan":
		portalArea.set_collision_mask_value(7, true)
	if player.color == "Orange":
		portalArea.set_collision_mask_value(6, true)


func checkIfInPortal() -> void:
	if not get_parent().get_node("PortalArea").has_overlapping_bodies():
		inPortal = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("PortalCollider") && !inPortal:
		
		var portal : ColorGate = body.get_parent() as ColorGate
		
		if portal.used:
			print("Portalen her er blevet brugt")
			return
		else:
			print("portal bliver brugt nu")
		
		if portal.pairedPortal.global_position.x + 50 < rightLimitCollision.global_position.x:
			inPortal = true
			previousPortal = portal
			
			var globalPointA = portal.to_global(portal.points[0])
			var globalPointB = portal.to_global(portal.points[1])
			
			var portalDirection = (globalPointB - globalPointA).normalized()
			var entryAngle = atan2(portalDirection.y, portalDirection.x)
			
			#normal vektor
			var portalNormal = Vector2(-portalDirection.y, portalDirection.x)
			
			#checker om retningens vektoren projekteret på portal vektoren er negativ (hvis ja så er det forskellige retning, hvis nej så er det samme)
			
			var globalExitPointA = portal.pairedPortal.to_global(portal.pairedPortal.points[0])
			var globalExitPointB = portal.pairedPortal.to_global(portal.pairedPortal.points[1])
			# Compute the direction and angle from the global points
			var exitDirection = (globalExitPointB - globalExitPointA).normalized()
			var exitAngle = atan2(exitDirection.y, exitDirection.x)
			
			#detection if first portal is entered from the back (if then ad pi to angle diff)
			if portal.pairedPortal.flipExitPortal:
				entryAngle += PI
			
			var angleDiff = exitAngle - entryAngle

			
			# Teleporter spiller
			player.global_position = portal.pairedPortal.global_position + (portal.pairedPortal.points[0] + (portal.pairedPortal.points[1] - portal.pairedPortal.points[0]) / 2).rotated(portal.pairedPortal.rotation)
			
			# rotere spiller baseret på forskellen
			var rotatingVector = player.velocity
			
			if !player.is_crouching:
				rotatingVector.x += Gamespeed.speed
				
			rotatingVector = rotatingVector.rotated(angleDiff)
			rotatingVector.x -= Gamespeed.speed
			player.velocity = rotatingVector
			
			# Sættes kun på computeren for den, der har brugt portalen
			portal.pairedPortal.used = true
			portal.used = true




func _on_area_2d_body_exited(body: Node2D) -> void:
	print("Ud af portalen")
	if previousPortal:
		if body.is_in_group("PortalCollider"):
			var portal : ColorGate = body.get_parent()
			if portal.pairedPortal == previousPortal:
				var portalCollider : StaticBody2D = portal.get_node("StaticBody2D")
				inPortal = false
				
