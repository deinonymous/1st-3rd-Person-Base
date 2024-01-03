extends State

class_name JumpState
var classname = "JumpState"

func _ready():
  persistent_state.animation.play("jump")
  persistent_state.velocity.y += persistent_state.jump_velocity
  jump()

func jump():
  var direction = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward").rotated(-persistent_state.camera.rotation.y)
  if direction:
    persistent_state.velocity.x = clampf(
      persistent_state.velocity.x + direction.x * persistent_state.midair_correction_speed,
      -persistent_state.run_speed,
      persistent_state.run_speed
    )
    persistent_state.velocity.z = clampf(
      persistent_state.velocity.z + direction.y * persistent_state.midair_correction_speed,
      -persistent_state.run_speed,
      persistent_state.run_speed
    )
  else:
    persistent_state.velocity.x /= 1.2
    persistent_state.velocity.z /= 1.2
  persistent_state.velocity.y -= Physics.gravity
  if persistent_state.velocity.y <= 0:
    fall()

func fall():
  change_state.call("fall")

#func walk():
#  pass

#func run():
  pass

#func idle():
#  pass
