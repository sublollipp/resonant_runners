extends Node2D

@onready var cam_controller = %CamController

var totalWidth : int
var segmentsList = []
var file_count = 0
var rng = RandomNumberGenerator.new()

#SLET SEGMENTER

func load_segments():  
	var dir = DirAccess.open("res://Scenes/BackgroundBuildings/")
	if dir:
		
		var files = dir.get_files()
		
		for file in files:
			if file.ends_with(".tscn"):
				file_count += 1
			segmentsList.append(load("res://Scenes/BackgroundBuildings/"+file))

func add_segment():
	for q in range(5):
		rng.randomize()
		var i = rng.randi_range(0,file_count-1)
		var newInstance = segmentsList.get(i).instantiate()
		add_child(newInstance)
	
		var distBetween = rng.randi_range(100,700)
		newInstance.position.x = totalWidth + distBetween
		newInstance.position.y += 800
		totalWidth+=newInstance.width + distBetween
		newInstance.modulate = Color(0.5, 0.5, 0.5, 1)
	print("Der er ", get_child_count(), " bygninger")
	print("Den længst til venstre er ved ", get_child(0).position.x)
	print("Den længst til højre er ved ", get_child(get_child_count() - 1))
	
		
func on_timer(): #ineffektiv code burde lave et signal
	if cam_controller.position.x*8 > totalWidth - 10000 && get_child_count() < 40:
		add_segment()
	for currentSegment : Node2D in get_children():
		if cam_controller.global_position.x * get_parent().motion_scale.x > currentSegment.global_position.x + currentSegment.width + 100:
			currentSegment.queue_free()
	

func _ready():
	load_segments()
	on_timer()
