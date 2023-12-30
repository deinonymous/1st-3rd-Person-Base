extends State

class_name WalkState

var min_move_speed: float = 0.005

func _ready():
  animation.play("walk")
  walk()

func _physics_process(_delta):
  persistent_state.velocity *= persistent_state.friction if persistent_state.foot_cast.get_collision_count() > 0 else 1
  if persistent_state.velocity.length() < min_move_speed:
    change_state.call("idle")

func walk():
  var direction = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward").rotated(-persistent_state.camera.rotation.y)
  persistent_state.velocity.x += direction.x * persistent_state.walk_speed
  persistent_state.velocity.z += direction.y * persistent_state.walk_speed

func run():
  change_state.call("run")

func jump():
  walk()
  change_state.call("jump")

func fall():
  change_state.call("fall")

func idle():
  if persistent_state.velocity.length() < min_move_speed:
    change_state.call("idle")
