extends Node2D
var totalWidth : int
var segmentsList = []
@onready var camera_2d = $"../CamController/Camera2D"
var file_count = 0
var rng = RandomNumberGenerator.new()

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
		
		
	

func _ready():
	load_segments()
	var firstInstance = segmentsList.get(0).instantiate()
	add_child(firstInstance)
	totalWidth += firstInstance.width
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera_2d.position.x > totalWidth - 2000:
		add_segment()
