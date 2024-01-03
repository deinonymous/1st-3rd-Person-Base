extends State

class_name RunState
var classname = "RunState"

func _ready():
  persistent_state.animation.play("run")
  run()

func run():
  persistent_state.animation.speed_scale = (-1 if persistent_state.direction.y < 0 else 1) * persistent_state.velocity.length() * 25
  persistent_state.velocity.x = clampf(
    persistent_state.direction.x * persistent_state.run_speed,
    persistent_state.velocity.x - abs(persistent_state.direction.x * persistent_state.run_speed / 5),
    persistent_state.velocity.x + abs(persistent_state.direction.x * persistent_state.run_speed / 5)
  )
  persistent_state.velocity.z = clampf(
    persistent_state.direction.y * persistent_state.run_speed,
    persistent_state.velocity.z - abs(persistent_state.direction.y * persistent_state.run_speed / 5),
    persistent_state.velocity.z + abs(persistent_state.direction.y * persistent_state.run_speed / 5)
  )


func jump():
  change_state.call("jump")

func fall():
  change_state.call("fall")

func idle():
  change_state.call("idle")

func walk():
  change_state.call("walk")
