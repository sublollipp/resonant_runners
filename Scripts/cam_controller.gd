extends Node2D

@onready var centerx : int = $Camera2D.position.x
var positionOffset : float = 0

@export var lerpSpeed : float = 0.2 ## Kameraets hastighed når der skal ændres offset.
@export var rangeScale : float = 0.5  ## Hvor meget bevægelsen "udvider" banen - 0.5 vil f.eks. give 0.25 baners plads bagved kameraets statposition og foran kameraets startposition - 0.5 i alt

func _ready() -> void:
	print("Center X: ", centerx)

func _process(delta: float) -> void:
	var playerCount : int = 0
	var totalPos : int = 0
	for player : Player in get_tree().get_nodes_in_group("players"):
		playerCount += 1
		totalPos += player.position.x - centerx
		#print("Position: ", player.position.x)
	if playerCount:
		positionOffset = round((totalPos / playerCount) * rangeScale)
	$Camera2D.offset.x = lerp($Camera2D.offset.x, positionOffset, 0.2 * delta)
