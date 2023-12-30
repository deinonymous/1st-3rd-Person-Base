extends CharacterBody3D

class_name PlayerState

@onready var foot_cast: ShapeCast3D = $FootCast
@onready var camera: Camera3D = $Camera3D
@onready var state_log: Label = $CanvasLayer/StateLog
var state
var state_factory
var input_active

var friction = 0.6
var run_speed = 0.06
var walk_speed = 0.03
var jump_velocity = 0.16

func _ready():
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  state_factory = StateFactory.new()
  change_state("idle")

func _unhandled_input(event):
  if event is InputEventMouseMotion:
    camera.rotation.y -= event.relative.x/400
    camera.rotation.x -= event.relative.y/400
    camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(_delta):
  handle_input()
  move_and_collide(velocity)

func handle_input():
  if !foot_cast.get_collision_count():
    state.fall()
    return false
  if Input.is_action_just_pressed("jump"):
    state.jump()
    return true
  if Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward"):
    if Input.is_action_pressed("sprint"):
      state.run()
      return true
    state.walk()
    return true
  state.idle()
  return false

func change_state(new_state_name):
  if state != null:
    state.queue_free()
  state = state_factory.get_state(new_state_name).new()
  state.setup(func (state_string): change_state(state_string), $AnimationPlayer, self)
  state.name = "current_state"
  state_log.text = new_state_name
  add_child(state)
