extends Node2D

var wheel_scene = preload("res://wheel/wheel.tscn")

func spawn_wheel() -> void:
	var wheel = wheel_scene.instantiate()
	add_child(wheel)
	wheel.position = Vector2.ZERO
