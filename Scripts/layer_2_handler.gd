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
	newInstance.position.y += 800
	totalWidth+=newInstance.width + distBetween
	newInstance.modulate = Color(0.5, 0.5, 0.5, 1)
	#print("Der er ", get_child_count(), " bygninger")
	#print("Den længst til venstre er ved ", get_child(0).global_position.x)
	#rint("Den længst til højre er ved ", get_child(get_child_count() - 1).global_position.x)
	
		
func on_timer(): 
	if %LeftLimit.position.x - 150 > get_child(0).global_position.x:
		get_child(0).queue_free()
		add_segment()
	

func _ready():
	
	load_segments()
	for x in range(20):
		add_segment()
