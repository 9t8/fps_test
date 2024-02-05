extends CharacterBody3D


const SPEED := 6
const ACCEL_GROUND := 7
const ACCEL_AIR := 1
const JUMP_VEL := 3.5
const MOUSE_SENS := 0.0012

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera := $Camera3D


func _ready() -> void:
	# fullscreen and capture cursor
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	# rotate
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENS)
		camera.rotate_x(-event.relative.y * MOUSE_SENS)
		camera.rotation.x = clamp(camera.rotation.x, -PI / 2, PI / 2)


func _physics_process(delta: float) -> void:
	# jumping and gravity
	var accel: int
	if is_on_floor():
		accel = ACCEL_GROUND
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_VEL
	else:
		accel = ACCEL_AIR
		velocity.y -= gravity * delta
	
	# horizontal movement
	var input_dir := Input.get_vector('move_left', 'move_right', 'move_forward', 'move_backward')
	var target_mvmt := transform.basis * SPEED * Vector3(input_dir.x, 0, input_dir.y)
	velocity.x = lerpf(velocity.x, target_mvmt.x, accel * delta)
	velocity.z = lerpf(velocity.z, target_mvmt.z, accel * delta)
	
	move_and_slide()
