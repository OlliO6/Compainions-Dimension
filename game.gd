extends Node2D

var time: float
var finished: bool

func _process(delta: float) -> void:
	if finished:
		return
	time += delta

func restart() -> void:
	get_tree().reload_current_scene()

func finish() -> void:
	finished = true
	%TimeLabel.text = "Your time:  " + str(time)
