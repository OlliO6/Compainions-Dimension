@tool
extends Area2D

signal switched(active: bool)

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

@export var is_actived: bool:
	set(v):
		is_actived = v
		(func():
			$Sprite2D.flip_h = v).call_deferred()
		switched.emit(v)

var player_in_area: bool:
	set(v):
		player_in_area = v
		$Sprite2D.material.set("shader_parameter/outline_color", Color("#2dc7aa") if v else Color(0, 0, 0, 0))

func _ready() -> void:
	player_in_area = false

func _unhandled_input(event: InputEvent) -> void:
	if !event.is_echo() && event.is_action_pressed("interact"):
		is_actived = !is_actived

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_area = false
