extends State

class_name FallState
var classname = "FallState"

func _ready():
  persistent_state.animation.speed_scale = 1
  persistent_state.animation.play("fall")
  fall()

func fall():
  persistent_state.velocity.y -= Physics.gravity
  persistent_state.face_camera_direction()

func jump():
  if grounded():
    change_state.call("jump")

func walk():
  if grounded():
    change_state.call("walk")

func run():
  if grounded():
    change_state.call("run")

func idle():
  if grounded():
    change_state.call("idle")

func sneak():
  if grounded():
    change_state.call("sneak")

func crouch():
  if grounded():
    change_state.call("crouch")

func grounded():
  return persistent_state.foot_cast.get_collision_count() > 0
