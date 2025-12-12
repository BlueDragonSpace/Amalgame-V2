extends Control

@export var started = true

@onready var Animate: AnimationPlayer = $RootUI/Animate
@onready var Frontground: ColorRect = $RootUI/Frontground


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if started:
		Animate.stop()
		Frontground.modulate.a = 0.0
