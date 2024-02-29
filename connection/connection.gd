@tool
class_name Connection
extends Line2D

signal toggled(toggled: bool)
signal toggled_on
signal toggled_off

@export var is_toggled: bool:
	set(v):
		toggled.emit(v)
		if is_toggled && !v:
			toggled_off.emit()
		elif !is_toggled && v:
			toggled_on.emit()
		is_toggled = v
		material.set("shader_parameter/alpha", 1 if v else 0.3)

@export var receiver: ConnectionReceiver
var emitter: ConnectionEmitter

func _ready() -> void:
	emitter = get_parent().get_node("ConnectionEmitter")
	if !Engine.is_editor_hint():
		emitter.toggled.connect(set_toggled)
		toggled.connect(func(v): receiver.toggled.emit(v))
		toggled_on.connect(func(): receiver.toggled_on.emit())
		toggled_off.connect(func(): receiver.toggled_off.emit())
	points = [Vector2.ZERO, to_local(receiver.global_position)]
	material.set("shader_parameter/start_color", GlobalClass.dimension_colors[emitter.get_parent().dimension])
	material.set("shader_parameter/end_color", GlobalClass.dimension_colors[receiver.dimension])

func _physics_process(delta: float) -> void:
	points[1] = to_local(receiver.global_position)

func set_toggled(toggled: bool) -> void:
	is_toggled = toggled
