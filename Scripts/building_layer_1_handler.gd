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
	
	
	
func on_timer():
	if %LeftLimit.position.x - 150 > get_child(0).global_position.x:
		print("global: ", get_child(0).global_position.x, " : Pos: ", get_child(0).position.x)
	
		get_child(0).queue_free()
		add_segment()
	
func _ready():
	load_segments()
	for x in range(10):
		add_segment()
	
	
	on_timer()
