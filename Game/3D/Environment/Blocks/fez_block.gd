extends "res://Game/3D/Environment/Blocks/one_way_platform.gd"

var defaultSz = null

@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var area_collider: CollisionShape3D = $Area3D/CollisionShape3D

func _ready() -> void:
	defaultSz = sz
	Player.connect("camera_view_changed", camera_change)

func camera_change(direction) -> void:
	print(defaultSz)
	sz = defaultSz
	match(direction):
		"x":
			sz.x = 100
		"y":
			sz.y = 0.1
		"z":
			sz.z = 100
	change_size(sz) #changes the hitbox and mesh, but not the one-way collision area
	
