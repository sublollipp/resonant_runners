extends Node2D
var totalWidth : int
var segmentsList = []
var recentSegments = []

@export var timeoutSegments : int = 5

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
			segmentsList.append("res://Scenes/Segments/"+file)

func add_segment(seg : String) -> void:
	var newSegment = load(seg).instantiate()
	add_child(newSegment)
	newSegment.position.x += totalWidth
	newSegment.position.y = 50
	totalWidth += newSegment.width
	
		
func remove_segment():
	for currentSegment in get_children():
		if cam_controller.position.x > currentSegment.position.x + currentSegment.width + 300:
			currentSegment.queue_free()
			print("Der var et segment der døde")
		
	
func segmentAdd() -> void:
	if !GDSync.is_host(): return
	rng.randomize()
	var i = rng.randi_range(0,file_count-1)
	add_segment(segmentsList.get(i))
	GDSync.call_func(add_segment, [segmentsList.get(i)])
	recentSegments.append(segmentsList.get(i))
	segmentsList.remove_at(i)
	if recentSegments.size() > timeoutSegments:
		segmentsList.append(recentSegments.get(0))
		recentSegments.remove_at(0)
	file_count = segmentsList.size()

func _ready():
	load_segments()
	GDSync.expose_func(add_segment)
	GDSync.expose_func(remove_segment)
	if !GDSync.is_host(): return
	add_segment(segmentsList.get(0))
	GDSync.call_func(add_segment, [segmentsList.get(0)])


func _process(delta):
	if GDSync.is_host():
		if cam_controller.position.x > totalWidth - 1000:
			segmentAdd()
		GDSync.call_func(remove_segment)
