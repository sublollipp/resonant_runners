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
	rng.randomize()
	var i = rng.randi_range(0,file_count-1)
	var newInstance = segmentsList.get(i).instantiate()
	add_child(newInstance)
	
	var distBetween = rng.randi_range(100,700)
	newInstance.position.x = totalWidth + distBetween
	newInstance.position.y = 600
	totalWidth+=newInstance.width + distBetween
	newInstance.modulate = Color(0.8, 0.8, 0.8, 1)
		
func remove_segment():
	for currentSegment in get_children():
		if cam_controller.position.x > currentSegment.position.x + currentSegment.width + 300:
			currentSegment.queue_free()
	
func _ready():
	load_segments()
	add_segment()
	
func _process(delta): # dette skal fikses baseret på totalwidth og sidste bygning 8scaleres ligesom noden?
	if cam_controller.position.x*8 > totalWidth - 10000:
		add_segment()
	remove_segment()
