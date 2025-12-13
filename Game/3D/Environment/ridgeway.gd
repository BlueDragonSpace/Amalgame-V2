extends Node3D

# really this is more like the Giant's Causeway, but I disgress

@export var width = 4
@export var length = 4

const BASIC_BLOCK = preload("uid://ds7amdlrlk45e")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for w in range(width):
		for l in range(length):
			var block = BASIC_BLOCK.instantiate()
			
			block.position.x = w
			block.position.z = l
			
			block.sz.y = randf_range(0.2,5)
			
			add_child(block)
