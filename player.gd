class_name Player extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 3.56

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_range(0.1, 5.0, 0.01) var mouse_sensitivity := 1.3

@export var camera: Camera3D
@export var shoot_raycast: RayCast3D

var mouse_floating: bool

func _ready() -> void:
	set_mouse_floating(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"switch_mouse_mode"):
		set_mouse_floating(!mouse_floating)
	
	if mouse_floating: return
	
	if event is InputEventMouseMotion:
		global_rotation.y -= event.relative.x * mouse_sensitivity * 0.001
		camera.global_rotation.x -= event.relative.y * mouse_sensitivity * 0.001
		camera.global_rotation_degrees.x = clampf(camera.global_rotation_degrees.x, -80.0, 80.0)
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if mouse_floating:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

		move_and_slide()
		return
	
	if Input.is_action_just_pressed(&"jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector(&"left", &"right", &"forward", &"back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func set_mouse_floating(floating: bool) -> void:
	mouse_floating = floating
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if mouse_floating else Input.MOUSE_MODE_CAPTURED
