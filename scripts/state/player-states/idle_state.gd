extends State

class_name IdleState
var classname = "IdleState"

func _ready():
  persistent_state.animation.play("idle")

func walk():
  change_state.call("walk")

func run():
  change_state.call("run")

func fall():
  change_state.call("fall")

func idle():
  persistent_state.velocity *= 0.4

func jump():
  change_state.call("jump")

func crouch():
  change_state.call("crouch")
