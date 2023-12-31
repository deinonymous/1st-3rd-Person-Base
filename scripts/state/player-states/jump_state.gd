extends State

class_name JumpState

func _ready():
  persistent_state.animation.play("jump")
  persistent_state.velocity /= 1.5
  persistent_state.velocity.y += persistent_state.jump_velocity
  jump()

func jump():
  persistent_state.velocity.y -= Physics.gravity
  if persistent_state.velocity.y <= 0:
    fall()

func fall():
  change_state.call("fall")

func walk():
  pass

func run():
  pass

func idle():
  pass
