extends CharacterBody3D

class_name PlayerPersistentState

@onready var body: Node3D = $BodyMeshes/Head/Body
@onready var head: Node3D = $BodyMeshes/Head
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var foot_cast: ShapeCast3D = $FootCast
@onready var camera: Camera3D = $BodyMeshes/Head/Camera3D
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
var direction: Vector2 = Vector2(0,0)

func _ready():
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  state_factory = StateFactory.new()
  change_state("idle")

func _unhandled_input(event):
  #handle camera rotation

  if event is InputEventMouseMotion:
    head.rotation.y -= event.relative.x/40
    camera.rotation.x -= event.relative.y/40
    camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _process(_delta):
  state_elected = false
  handle_input()

func _physics_process(_delta):
  move_and_collide(velocity)
  move_and_slide()

func handle_input():
  #determine which states to attempt to transition to, according to player input

  #determine if player is trying to move f/b/l/r
  var input_direction = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward")
  direction = input_direction.rotated(-head.rotation.y)

  if input_direction.y > 0:
    body.rotation.y = clampf(-Vector2(0,-1).angle_to(-input_direction), body.rotation.y - 0.1, body.rotation.y + 0.1)
  else:
    body.rotation.y = clampf(-Vector2(0,-1).angle_to(input_direction), body.rotation.y - 0.1, body.rotation.y + 0.1)
  body.rotation.y = clampf(body.rotation.y, -PI/4, PI/4)

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
    if Input.is_action_pressed("sprint"):
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
