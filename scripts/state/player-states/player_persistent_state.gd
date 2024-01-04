extends CharacterBody3D

class_name PlayerPersistentState

@onready var body: Node3D = $BodyMeshes/Head/Body
@onready var head: Node3D = $BodyMeshes/Head
@onready var head_base: Node3D = $BodyMeshes/Head/Body/TorsoMesh/Neck/BaseOfHead
@onready var head_mesh: MeshInstance3D = $BodyMeshes/Head/Body/TorsoMesh/Neck/BaseOfHead/Head
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var foot_cast: ShapeCast3D = $FootCast
@onready var camera: Node3D = $BodyMeshes/Head/Camera
@onready var camera3d: Camera3D = $BodyMeshes/Head/Camera/Camera3D
@onready var state_log: Label = $CanvasLayer/StateLog

#state
var state
var state_factory
var state_elected: bool

#physics/motion
var inertia = 0.7
var run_speed = 0.1
var walk_speed = 0.05
var sneak_speed = 0.025
var midair_correction_speed = 0.002
var jump_velocity = 0.17
var input_direction: Vector2 = Vector2(0,0)
var direction: Vector2 = Vector2(0,0)

func _ready():
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  state_factory = StateFactory.new()
  change_state("idle")

func _unhandled_input(event):
  #handle camera rotation

  if event is InputEventMouseMotion:
    camera.rotation.y -= event.relative.x/40
    camera.rotation.x = clampf(camera.rotation.x - event.relative.y/40, deg_to_rad(-60), deg_to_rad(60))
    head_base.rotation.x = camera.rotation.x / 2

func _process(_delta):
  state_elected = false
  handle_input()

func _physics_process(_delta):
  move_and_collide(velocity)
  move_and_slide()

func handle_input():
  #determine which states to attempt to transition to, according to player input

  #determine if player is trying to move f/b/l/r
  input_direction = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward")
  direction = input_direction.rotated(-camera.rotation.y)

  handle_camera_zoom()

  #fall if not on the ground
  if !foot_cast.get_collision_count() and velocity.y <= 0:
    state.do_state("fall")

  #handle jump
  if Input.is_action_just_pressed("jump") or state is JumpState:
    state.do_state("jump")

  #handle crouch/sneak
  if Input.is_action_pressed("crouch"):
    if input_direction:
      state.do_state("sneak")
    state.do_state("crouch")

  #handle plain movement
  if input_direction:
    if Input.is_action_pressed("sprint") and input_direction.y < 0:
      state.do_state("run")
    state.do_state("walk")

  #otherwise, player is idle
  state.do_state("idle")

func change_state(new_state_name):
  #set the new state by name

  #remove any previous state
  if state != null:
    state.queue_free()

  #instantiate target state by looking up its name in the state factory
  state = state_factory.get_state(new_state_name).new()
  print(new_state_name)

  #set up the instantiated state so it can call THIS FUNCTION to change state,
  #play the appropriate player animation,
  #and modify the player's variables
  state.setup(func (state_string): change_state(state_string), self)
  state.name = "current_state"
  state_log.text = new_state_name
  add_child(state)

func face_movement_direction():
  if input_direction.y > 0:
    body.rotation.y = clampf(camera.rotation.y-Vector2(0,-1).angle_to(-input_direction), body.rotation.y - 0.1, body.rotation.y + 0.1)
  else:
    body.rotation.y = clampf(camera.rotation.y-Vector2(0,-1).angle_to(input_direction), body.rotation.y - 0.1, body.rotation.y + 0.1)
  head_base.rotation.y = (camera.rotation.y - body.rotation.y) / 2.0

func face_camera_direction():
  if camera3d.position.z >= 0.4:
    body.rotation.y = clampf(camera.rotation.y, body.rotation.y - 0.1, body.rotation.y + 0.1)
  else:
    body.rotation.y = clampf(body.rotation.y, camera.rotation.y - PI/4, camera.rotation.y + PI/4)
  head_base.rotation.y = (camera.rotation.y - body.rotation.y) / 4.0

func handle_camera_zoom():
  var camera_zoom_input = -float(int(Input.is_action_just_released("camera_zoom_in")))/5.0 + float(int(Input.is_action_just_released("camera_zoom_out")))/5.0
  if camera_zoom_input:
    camera3d.position.z = clampf(camera3d.position.z + camera_zoom_input, -0.20, 2.5)
  if camera3d.position.z < 0.4:
    if Input.is_action_just_released("camera_zoom_in"):
      camera3d.position = Vector3(0.0, 0.2, -0.1)
      var material: Material = head_mesh.get_active_material(0)
      material.albedo_color.a = 0.0
    elif Input.is_action_just_released("camera_zoom_out"):
      var material: Material = head_mesh.get_active_material(0)
      material.albedo_color.a = 1.0
      camera3d.position.z = 0.4
      head_mesh.set_visible(true)
  else:
    camera3d.position.x = 0.365
    camera3d.position.y = clampf((0.5 + camera3d.position.y + camera_zoom_input)/10, 0.3, 3.5)
