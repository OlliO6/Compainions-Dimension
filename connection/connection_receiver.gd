class_name ConnectionReceiver
extends Node2D

signal toggled(toggled: bool)
signal toggled_on
signal toggled_off

@export_enum("All", "Player", "Other") var dimension: int
