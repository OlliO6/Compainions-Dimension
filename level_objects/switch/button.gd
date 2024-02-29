@tool
extends Area2D

signal pressed
signal unpressed

@export var multiple_presses: bool = true

# 0: all 1: player 2: other
@export_enum("All", "Player", "Other") var dimension: int:
	set(v):
		dimension = v
		(func():
			set_collision_layer_value(1, dimension == 0)
			set_collision_layer_value(2, dimension == 1)
			set_collision_layer_value(3, dimension == 2)
			set_collision_mask_value(1, dimension == 0)
			set_collision_mask_value(2, dimension == 1)
			set_collision_mask_value(3, dimension == 2)
			$Sprite2D.material.set("shader_parameter/color", GlobalClass.dimension_colors[dimension])).call_deferred()

var is_pressed: bool:
	set(v):
		is_pressed = v
		($Sprite2D as Sprite2D).frame = int(v)

var player_in_area: bool:
	set(v):
		player_in_area = v
		$Sprite2D.material.set("shader_parameter/outline_color", Color("#2dc7aa") if v else Color(0, 0, 0, 0))

func _ready() -> void:
	player_in_area = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func press() -> void:
	if is_pressed:
		return
	
	is_pressed = true
	pressed.emit()
	$AudioStreamPlayer.play()
	if multiple_presses:
		$Timer.start()

func unpress() -> void:
	is_pressed = false
	unpressed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if player_in_area && !event.is_echo() && event.is_action_pressed("interact"):
		press()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_area = true
	elif body.is_in_group("interact"):
		press()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_area = false
