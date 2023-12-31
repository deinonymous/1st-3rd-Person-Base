extends State

class_name SneakState

func _ready():
  persistent_state.animation.play("sneak")
  persistent_state.transition_camera_height(persistent_state.camera_crouch_height)
  sneak()

func sneak():
  var direction = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward").rotated(-persistent_state.camera.rotation.y)
  persistent_state.velocity.x = direction.x * persistent_state.sneak_speed
  persistent_state.velocity.z = direction.y * persistent_state.sneak_speed

func crouch():
  change_state.call("crouch")

func walk():
  persistent_state.transition_camera_height(persistent_state.camera_standing_height)
  change_state.call("walk")

func run():
  pass

func jump():
  pass

func fall():
  persistent_state.transition_camera_height(persistent_state.camera_standing_height)
  change_state.call("fall")

func idle():
  pass
