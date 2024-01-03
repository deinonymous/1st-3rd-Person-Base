extends CharacterBody3D

class_name PlayerPersistentState

@onready var body: Node3D = $BodyMeshes
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var foot_cast: ShapeCast3D = $FootCast
@onready var camera: Camera3D = $Camera3D
@onready var state_log: Label = $CanvasLayer/StateLog

#state
var state
var state_factory
var state_changed: bool

#physics/motion
var inertia = 0.7
var run_speed = 0.1
var walk_speed = 0.05
var sneak_speed = 0.025
var midair_correction_speed = 0.002
var jump_velocity = 0.17

#camera
var bob_time = 0.0
var camera_standing_height = 0.5
var camera_crouch_height = 0.0
var camera_current_height = camera_standing_height
var camera_height_tween: Tween

func _ready():
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  state_factory = StateFactory.new()
  change_state("idle")

func _unhandled_input(event):
  #handle camera rotation

  if event is InputEventMouseMotion:
    camera.rotation.y -= event.relative.x/40
    camera.rotation.x -= event.relative.y/40
    camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
    body.rotation.y = camera.rotation.y

func _physics_process(_delta):
  state_changed = false
  handle_input()
  move_and_collide(velocity)
  move_and_slide()
  view_bob(_delta)

func handle_input():
  #determine which states to attempt to transition to, according to player input

  #determine if player is trying to move f/b/l/r
  var direction = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward")

  #fall if not on the ground
  if !foot_cast.get_collision_count() and velocity.y <= 0:
    state.do_state("fall")

  #handle jump
  if Input.is_action_just_pressed("jump") or state is JumpState:
    state.do_state("jump")

  #handle crouch/sneak
  if Input.is_action_pressed("crouch"):
    if direction:
      state.do_state("sneak")
    state.do_state("crouch")

  #handle plain movement
  if direction:
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

func view_bob(_delta):
  if velocity.length() and not velocity.y:
    bob_time += _delta * 180 * velocity.length()
    camera.position.y = camera_current_height + sin(bob_time) / 25
  elif abs(camera.position.y-camera_current_height) != camera_current_height:
    camera.position.y = camera_current_height
    bob_time = 0

func transition_camera_height(_new_height):
  if _new_height != camera_current_height:
    if camera_height_tween:
      camera_height_tween.kill()
    camera_height_tween = create_tween()
    camera_height_tween.tween_property(self, "camera_current_height", _new_height, 0.4).set_trans(Tween.TRANS_CUBIC)
