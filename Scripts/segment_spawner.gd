extends Node2D
var totalWidth : int

var easySegments = []
var easyRecentSegments = []
var mediumSegments = []
var mediumRecentSegments = []
var hardSegments = []
var hardRecentSegments = []

var aliveSegments = 0

var easyFile_count = 0
var mediumFile_count = 0
var hardFile_count = 0

var turtorialLevel = "res://Scenes/Segments/ATutorial.tscn"

@export var timeoutSegments : int = 5

@onready var cam_controller = $"../CamController" #denne opdateres ikke

var rng = RandomNumberGenerator.new()

var startTime : float
var currentTime : float
var totalUsedTime : float = 0
#SLET SEGMENTER

func load_segments(segmentsList, diff):
	var dir = DirAccess.open("res://Scenes/Segments/"+diff)
	if dir:
		var files = dir.get_files()
		
		for file in files:
			segmentsList.append("res://Scenes/Segments/"+diff+file)
	return segmentsList.size()

func add_segment(seg : String, diff) -> void:
	var newSegment = load(seg).instantiate()
	var jumpBetweenSegments = 0
	add_child(newSegment)
	
	aliveSegments += 1
	print("CURRENT SEGMETNS COUNT: ",aliveSegments)
	
	match diff:
		"easy":
			jumpBetweenSegments = 32
		"medium":
			jumpBetweenSegments = 64
		"hard":
			jumpBetweenSegments = 96
		"none":
			jumpBetweenSegments = 0
			
	totalWidth += jumpBetweenSegments
	newSegment.position.x += totalWidth
	newSegment.position.y = 50
	totalWidth += newSegment.width

func remove_segment():
	for currentSegment in get_children():
		if cam_controller.position.x > currentSegment.position.x + currentSegment.width + 300:
			currentSegment.queue_free()
			aliveSegments -= 1
			print("CURRENT SEGMETNS COUNT: ",aliveSegments)

func segmentAdd(segmentsList, recentSegments, file_count, diff) -> void:
	if !GDSync.is_host(): return
	rng.randomize()
	var i : int
	
	if (file_count > 1):
		i = rng.randi_range(1,segmentsList.size()-1)
	else:
		i = 0
	add_segment(segmentsList.get(i), diff)
	GDSync.call_func(add_segment, [segmentsList.get(i), diff])
	
	if timeoutSegments > 0:
		recentSegments.append(segmentsList.get(i))
		segmentsList.remove_at(i)
		if recentSegments.size() > timeoutSegments:
			segmentsList.append(recentSegments.get(0))
			recentSegments.remove_at(0)
		file_count = segmentsList.size()
		
		var newList = segmentsList.duplicate()
		segmentsList = newList


func _ready():
	Gamespeed.speed = 30
	startTime = Time.get_ticks_msec()/1000
	
	#load filer og sætter file count
	easyFile_count = load_segments(easySegments,"Easy/")
	mediumFile_count = load_segments(mediumSegments,"Medium/")
	hardFile_count = load_segments(hardSegments,"Hard/")
	
	
	GDSync.expose_func(add_segment)
	GDSync.expose_func(remove_segment)
	if !GDSync.is_host(): return
	add_segment(turtorialLevel, "none")
	GDSync.call_func(add_segment, [turtorialLevel,"none"])


func _process(delta):
	currentTime = Time.get_ticks_msec()/1000 - startTime



func dificulty():
	if currentTime < 230:
		return "easy"
	elif currentTime < 380:
		rng.randomize()
		if 1 == rng.randi_range(1,2):
			return "medium"
		else:
			return "easy"
	elif currentTime < 530:
		return "medium"
	elif currentTime < 680:
		if 1 == rng.randi_range(1,2):
			return "medium"
		else:
			return "hard"
	else:
		return "hard"


func speedRamping():
	if Gamespeed.speed > 1: #døds check
		Gamespeed.speed += 1



func _on_timer_timeout():
	if Gamespeed.speed <= 100:
		speedRamping()
	
	if GDSync.is_host():
		GDSync.call_func(remove_segment)
		remove_segment()
		
		var diff = dificulty()
		if cam_controller.position.x > totalWidth - 1000:
			match diff:
				"easy":
					segmentAdd(easySegments,easyRecentSegments,easyFile_count,"easy")
				"medium":
					segmentAdd(mediumSegments,mediumRecentSegments,mediumFile_count,"medium")
				"hard":
					segmentAdd(hardSegments,hardRecentSegments,hardFile_count,"hard")

		
