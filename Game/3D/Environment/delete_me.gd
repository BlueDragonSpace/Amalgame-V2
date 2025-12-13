extends "res://Game/3D/Environment/basic_block.gd"

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("blowUpEnv"):
		collision_shape_3d.shape.size.x += 10
