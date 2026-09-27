extends CharacterBody3D

var movement_speed = 5.0
var mouse_sensitivity = 0.001
var jump_velocity = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity)
        camera.rotate_x(-event.relative.y * mouse_sensitivity)
        camera.rotation.x = clamp(
            camera.rotation.x,
            deg_to_rad(-90),
            deg_to_rad(90)
        )

    if event.is_action_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
    var input_dir = Input.get_vector(
        "move_left",
        "move_right",
        "move_forward",
        "move_back"
    )

    var direction = (
        camera_pivot.global_transform.basis *
        Vector3(input_dir.x, 0, input_dir.y)
    ).normalized()

    if direction:
        velocity.x = direction.x * movement_speed
        velocity.z = direction.z * movement_speed
    else:
        velocity.x = move_toward(velocity.x, 0, movement_speed)
        velocity.z = move_toward(velocity.z, 0, movement_speed)

    if not is_on_floor():
        velocity.y -= gravity * delta

    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

    move_and_slide()

