@tool
class_name Block
extends StaticBody2D

# 0: all 1: player 2: other
@export_enum("All", "Player", "Other") var dimension: int:
	set(v):
		dimension = v
		(func():
			set_collision_layer_value(1, dimension == 0)
			set_collision_layer_value(2, dimension == 1)
			set_collision_layer_value(3, dimension == 2)
			$Sprite2D.modulate = GlobalClass.dimension_colors[dimension]).call_deferred()

@export var is_solid: bool:
	set(v):
		is_solid = v
		if has_node("GPUParticles2D"):
			$GPUParticles2D.restart()
		(func():
			$Sprite2D.frame = 0 if v else 1
			$CollisionShape2D.disabled = !is_solid).call_deferred()

func set_solid(solid: bool) -> void:
	is_solid = solid
