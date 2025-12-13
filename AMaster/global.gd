extends Node

# this serves as a GLOBAL variable tracker, across both 2d and 3d
# it also serves as my dev controls

var devMode = true

func _process(_delta: float) -> void:
	
	if devMode:
		if Input.is_action_just_pressed("DevRestart"):
			get_tree().reload_current_scene()
