extends State

class_name WalkState

func _ready():
  persistent_state.animation.play("walk")
  walk()

func walk():
  var direction = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward").rotated(-persistent_state.camera.rotation.y)
  persistent_state.velocity.x = clampf(
    direction.x * persistent_state.walk_speed,
    persistent_state.velocity.x - abs(direction.x * persistent_state.walk_speed / 10),
    persistent_state.velocity.x + abs(direction.x * persistent_state.walk_speed / 10)
  )
  persistent_state.velocity.z = clampf(
    direction.y * persistent_state.walk_speed,
    persistent_state.velocity.z - abs(direction.y * persistent_state.walk_speed / 10),
    persistent_state.velocity.z + abs(direction.y * persistent_state.walk_speed / 10)
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
