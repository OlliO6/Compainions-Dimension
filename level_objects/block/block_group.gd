@tool
extends Node2D

@export var is_solid: bool:
	set(v):
		is_solid = v
		for i in get_children():
			if i is Block:
				i.is_solid = v

func set_solid(solid: bool):
	is_solid = solid
