extends Node3D

# NOT meant for manipulation in the editor, but the animation
@export var transitionNum = 0.0 #from 0.0 to 1.0, helps to handle camera rotation inbetween

@onready var path_3d: Path3D = $Cameras/Path3D

@onready var start: Camera3D = $Cameras/Start
@onready var end: Camera3D = $Cameras/End
@onready var in_between: Camera3D = $Cameras/Path3D/PathFollow3D/InBetween
@onready var path_follow_3d: PathFollow3D = $Cameras/Path3D/PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path_3d.curve.add_point(start.position)
	path_3d.curve.add_point(end.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	path_follow_3d.set_deferred("rotation", Vector3.ZERO)
	
	in_between.rotation = start.rotation.lerp(end.rotation, transitionNum)
