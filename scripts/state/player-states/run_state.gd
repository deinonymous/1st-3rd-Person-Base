extends State

class_name RunState

func _ready():
  persistent_state.animation.play("run")
  run()

func run():
  var direction = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward").rotated(-persistent_state.camera.rotation.y)
  persistent_state.velocity.x = direction.x * persistent_state.run_speed
  persistent_state.velocity.z = direction.y * persistent_state.run_speed

func jump():
  change_state.call("jump")

func fall():
  change_state.call("fall")

func idle():
  change_state.call("idle")

func walk():
  change_state.call("walk")
