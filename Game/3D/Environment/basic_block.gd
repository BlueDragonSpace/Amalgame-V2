extends StaticBody3D

@export var sz = Vector3(1.0, 1.0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	$CollisionShape3D.shape.size = sz
	$MeshInstance3D.mesh.size = sz
