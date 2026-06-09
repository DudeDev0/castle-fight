extends Node


enum Type {
	DEFEND,
	ATTACK,
	HEAL
}

var all: Dictionary
var current: Dictionary

func _ready() -> void:
	# Default
	all["block1x1"] = [preload("res://assets/block1x1.blend"), 1, 1, Type.DEFEND]
	all["block2x2"] = [preload("res://assets/block2x2.blend"), 2, 2, Type.DEFEND]

	for key in all:
		current[key] = all[key]
