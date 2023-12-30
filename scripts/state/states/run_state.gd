extends State

class_name RunState

func _ready():
  animation.play("run")
  run()

func _physics_process(_delta):
  persistent_state.velocity *= persistent_state.friction if persistent_state.foot_cast.get_collision_count() > 0 else 1
  if persistent_state.velocity.length() <= persistent_state.walk_speed and persistent_state.foot_cast.get_collision_count():
    change_state.call("walk")

func run():
  var direction = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward").rotated(-persistent_state.camera.rotation.y)
  persistent_state.velocity.x += direction.x * persistent_state.run_speed
  persistent_state.velocity.z += direction.y * persistent_state.run_speed

func jump():
  change_state.call("jump")

func idle():
  change_state.call("idle")

func walk():
  change_state.call("walk")
