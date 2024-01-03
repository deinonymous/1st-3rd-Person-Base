extends State

class_name WalkState
var classname = "WalkState"

func _ready():
  persistent_state.animation.play("walk")
  walk()

func walk():
  persistent_state.animation.speed_scale = (-1 if persistent_state.direction.y < 0 else 1) * persistent_state.velocity.length() * 25
  persistent_state.velocity.x = clampf(
    persistent_state.direction.x * persistent_state.walk_speed,
    persistent_state.velocity.x - abs(persistent_state.direction.x * persistent_state.walk_speed / 10),
    persistent_state.velocity.x + abs(persistent_state.direction.x * persistent_state.walk_speed / 10)
  )
  persistent_state.velocity.z = clampf(
    persistent_state.direction.y * persistent_state.walk_speed,
    persistent_state.velocity.z - abs(persistent_state.direction.y * persistent_state.walk_speed / 10),
    persistent_state.velocity.z + abs(persistent_state.direction.y * persistent_state.walk_speed / 10)
  )

func run():
  change_state.call("run")

func jump():
  change_state.call("jump")

func fall():
  change_state.call("fall")

func idle():
  change_state.call("idle")

func sneak():
  change_state.call("sneak")

func crouch():
  change_state.call("crouch")
