extends "res://Game/3D/Environment/basic_block.gd"

# by default, this platform doesn't collide with the player.
# 

@onready var collider: CollisionShape3D = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collider.set_deferred("disabled", true)

func _on_area_3d_body_entered(body: Node3D) -> void:
	# if heading upward or not moving in the y-axis, turn the collider off
	if body.velocity.y < 0:
		collider.set_deferred("disabled", false)
		
	else:
		collider.set_deferred("disabled", true)


func _on_area_3d_body_exited(_body: Node3D) -> void:
	# makes sure the collider is set to disabled when they come back to the platform
	collider.set_deferred("disabled", true)
