extends State

class_name JumpState

func _ready():
  animation.play("jump")
  jump()

func jump():
  persistent_state.velocity.x *= 0.9
  persistent_state.velocity.z *= 0.9
  if persistent_state.foot_cast.get_collision_count():
    persistent_state.velocity.y = persistent_state.jump_velocity
  else:
    fall()

func fall():
  change_state.call("fall")

func idle():
  pass
