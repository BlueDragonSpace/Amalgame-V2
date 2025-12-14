extends "res://Game/3D/Environment/Blocks/one_way_platform.gd"

var defaultSz = null
const player_y_safety = 0.601

@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var area_collider: CollisionShape3D = $Area3D/CollisionShape3D

func _ready() -> void:
	defaultSz = sz
	Player.connect("camera_view_changing", camera_change)

func camera_change(direction) -> void:
	
	#changes hitbox (and mesh, currently) size
	sz = defaultSz
	match(direction):
		"x":
			sz.x = 100
		"y":
			sz.y = 0.1
		"z":
			sz.z = 100
	change_size(sz, true) #changes the hitbox and mesh, but not the one-way collision area
	
	# teleports the player to be on the middle of this block, when the camera moves, if they're on it
	# only moves in the direction the camera can't see currently
	
	# I'm pretty sure this is related to the order of the cameras, (the previous direction, rather than the current one)
	if player_on_block:
		match(direction):
			"x":
				Player.position.z = global_position.z
			"y":
				Player.position.x = global_position.x
			"z":
				pass
		Player.position.y = global_position.y + player_y_safety #makes sure player lands on top of platform
