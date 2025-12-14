extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

@onready var Animate: AnimationPlayer = $Animate

## CAMERA stuff
@export var camera_type = 0
@export var camera_mouse_rotate = true

@onready var Cameras: Node3D = $Cameras
@onready var InBetweenCamera: Camera3D = $InBetweenPath/PathFollow3D/InBetweenCamera
@onready var InBetweenPath: Path3D = $InBetweenPath
@onready var InBetweenPathFollow: PathFollow3D = $InBetweenPath/PathFollow3D
var camera_between_start_rotation = Vector3.ZERO 
enum CAMERA_DIRECTIONS {
	FORWARD,
	RIGHT,
}
var camera_to_player_direction = CAMERA_DIRECTIONS.FORWARD

signal camera_view_changed

var CurrentCamera: Camera3D = null
@export_category("ANIMATION ONLY EXPORTS")
@export var cameraAnimatePosition = 0.0 #from 0 to 1, aids in rotation and other value tweening


func _ready() -> void:
	CurrentCamera = Cameras.get_child(camera_type)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("3DJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir = null
	# Get the input direction and handle the movement/deceleration.
	match(camera_to_player_direction):
		CAMERA_DIRECTIONS.FORWARD:
			input_dir = Input.get_vector("3DLeft", "3DRight", "3DForward", "3DBackward")
		CAMERA_DIRECTIONS.RIGHT:
			input_dir = Input.get_vector("3DForward", "3DBackward", "3DRight", "3DLeft")
	#var input_dir := Input.get_vector("3DLeft", "3DRight", "3DForward", "3DBackward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and CurrentCamera.current:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _process(_delta: float) -> void:
	
	CurrentCamera.rotation.x = clamp(CurrentCamera.rotation.x, -PI/2, PI/2)
	
	if Input.is_action_just_pressed("Click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_pressed("Escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("CameraSwitch"):
		
		InBetweenCamera.current = true
		InBetweenCamera.rotation = CurrentCamera.rotation
		InBetweenPath.curve.clear_points()
		InBetweenPath.curve.add_point(CurrentCamera.position)
		
		camera_between_start_rotation = CurrentCamera.rotation 
		
		camera_type += 1
		if camera_type > Cameras.get_child_count() - 1:
			camera_type = 0
		CurrentCamera = Cameras.get_child(camera_type) #switches from before camera to after camera
		
		InBetweenPath.curve.add_point(CurrentCamera.position)
		
		Animate.play("InBetweenCamera")
	
	# animating camera still
	# lerps the camera from start rotation to end rotation, based on it's ratio of being finished in the timeline
	if Animate.current_animation == "InBetweenCamera":
		InBetweenCamera.rotation = camera_between_start_rotation.lerp(CurrentCamera.rotation, cameraAnimatePosition)
		
	# makes sure that the path follow doesn't curve in the direction of the path the inbetween takes
	InBetweenPathFollow.set_deferred("rotation", Vector3.ZERO)
	
	
func _input(event) -> void:
	
	# this depends on the camera type...
	#if event is InputEventMouseMotion and InBetweenCamera.current == false:
	if event is InputEventMouseMotion and camera_mouse_rotate:
		rotation.y += -event.relative.x * .001
		CurrentCamera.rotation.x += -event.relative.y * .001

func finishCameraSwitch() -> void:
	CurrentCamera.current = true
	CurrentCamera.rotation = InBetweenCamera.rotation
	
	if CurrentCamera.name == "Head90":
		camera_to_player_direction = CAMERA_DIRECTIONS.RIGHT
	else:
		camera_to_player_direction = CAMERA_DIRECTIONS.FORWARD
	
	var non_existant_direction_in_relation_to_the_camera = null
	match(CurrentCamera.name):
		"Bird":
			non_existant_direction_in_relation_to_the_camera = "y"
		"Head":
			non_existant_direction_in_relation_to_the_camera = "z"
		"Head90":
			non_existant_direction_in_relation_to_the_camera = "x"
	camera_view_changed.emit(non_existant_direction_in_relation_to_the_camera)
