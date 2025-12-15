extends "res://Game/3D/Environment/Blocks/one_way_platform.gd"

var defaultSz = null
var defaultPos = null
const player_y_safety = 0.601

@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var area_collider: CollisionShape3D = $Area3D/CollisionShape3D

func _ready() -> void:
	defaultSz = sz
	defaultPos = position
	Player.connect("camera_view_changing", camera_change)
	Player.connect("camera_view_changed", camera_change_after)

func camera_change(direction) -> void:
	
	#changes hitbox (and mesh, currently) size
	sz = defaultSz
	position = defaultPos
	match(direction):
		"x":
			sz.x = 100
		"y":
			sz.y = 0.1
			#position.y = 0.0 # after camera moves change position
		"z":
			sz.z = 100
	change_size(sz, true) #changes the hitbox and collider, but not the mesh art
	
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
	
	if player_inside_block and direction == "z":
		Player.position.y = global_position.y + player_y_safety #makes sure player lands on top of platform
	

func camera_change_after(direction) -> void:
	
	#gets restarted at the start(ing function)
	
	if direction == "y":
		Player.global_position.y = 0.5
		position.y = 0
