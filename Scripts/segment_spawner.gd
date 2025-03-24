extends Node2D
var totalWidth : int
var segmentsList = []
@onready var cam_controller = $"../CamController" #denne opdateres ikke
var file_count = 0
var rng = RandomNumberGenerator.new()

#SLET SEGMENTER

func load_segments():  
	var dir = DirAccess.open("res://Scenes/Segments/")
	if dir:
		
		var files = dir.get_files()
		
		for file in files:
			if file.ends_with(".tscn"):
				file_count += 1
			segmentsList.append(load("res://Scenes/Segments/"+file))

func add_segment():
	rng.randomize()
	var i = rng.randi_range(0,file_count-1)
	var newInstance = segmentsList.get(i).instantiate()
	add_child(newInstance)
	newInstance.position.x += totalWidth
	totalWidth+=newInstance.width
		
func remove_segment():
	for currentSegment in get_children():
		if cam_controller.position.x > currentSegment.position.x + currentSegment.width + 300:
			print("free")
			currentSegment.queue_free()
		
	

func _ready():
	load_segments()
	var firstInstance = segmentsList.get(0).instantiate()
	add_child(firstInstance)
	totalWidth += firstInstance.width
	
	


func _process(delta):
	if cam_controller.position.x > totalWidth - 1000:
		add_segment()
	remove_segment()
