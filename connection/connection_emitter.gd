class_name ConnectionEmitter
extends Node

signal toggled(toggled: bool)

func emit_toggled(_toggled: bool) -> void:
	toggled.emit(_toggled)
