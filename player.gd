class_name Player extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 3.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity := 3.0

@onready var camera: Camera3D = $Camera3D
@onready var shoot_raycast: RayCast3D = $Camera3D/ShootRaycast

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var delta = get_process_delta_time()
		global_rotation.y -= event.relative.x * delta * mouse_sensitivity
		camera.global_rotation.x -= event.relative.y * delta * mouse_sensitivity
	elif event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("shoot"):
		if shoot_raycast.is_colliding():
			var collision_point = shoot_raycast.get_collision_point()
			var collision_normal = shoot_raycast.get_collision_normal()
			# create portal at collision point
			print("hit")
		else:
			print("didn't hit")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
