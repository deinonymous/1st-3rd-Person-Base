extends State

class_name IdleState

func _ready():
  animation.play("idle")
  persistent_state.velocity = Vector3(0,0,0)

func walk():
  change_state.call("walk")

func run():
  change_state.call("run")

func fall():
  change_state.call("fall")

func idle():
  pass

func jump():
  change_state.call("jump")
