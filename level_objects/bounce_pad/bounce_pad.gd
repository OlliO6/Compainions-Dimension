@tool
extends Area2D

@export var boost: float = 10

@export_enum("All", "Player", "Other") var dimension: int:
	set(v):
		dimension = v
		set_collision_layer_value(1, dimension == 0)
		set_collision_layer_value(2, dimension == 1)
		set_collision_layer_value(3, dimension == 2)
		set_collision_mask_value(1, dimension == 0)
		set_collision_mask_value(2, dimension == 1 || dimension == 0)
		set_collision_mask_value(3, dimension == 2 || dimension == 0)
		modulate = GlobalClass.dimension_colors[dimension]

@export var is_active: bool:
	set = set_active

func _ready() -> void:
	dimension = dimension
	set_active(is_active)

func set_active(v):
	is_active = v
	if is_active:
		for i in get_overlapping_bodies():
			_on_body_entered(i)
	(func(): $GPUParticles2D.emitting = v).call_deferred()

func _on_body_entered(body: Node2D) -> void:
	if !is_active:
		return
	
	if body is Player:
		await get_tree().physics_frame
		body.bounce(boost)
	elif body is RigidBody2D:
		body.linear_velocity.y = -boost
