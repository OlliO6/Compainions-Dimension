extends Node2D

var time: float
var finished: bool

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta: float) -> void:
	if finished:
		return
	time += delta

func restart() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().process_frame
	get_tree().reload_current_scene()

func finish() -> void:
	finished = true
	%TimeLabel.text = "Your time:  " + _get_time_string()

func _get_time_string() -> String:
	var seconds: int = roundi(time)
	var minutes: int = 0
	
	while seconds >= 60:
		minutes += 1
		seconds -= 60
	
	return str(minutes) + ":" + ("0" if seconds < 10 else "") + str(seconds)
