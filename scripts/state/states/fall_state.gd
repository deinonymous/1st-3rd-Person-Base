extends State

class_name FallState

func _ready():
  animation.play("fall")
  fall()

func fall():
  if !persistent_state.foot_cast.get_collision_count() > 0:
    persistent_state.velocity.y -= Physics.gravity

func jump():
  if persistent_state.foot_cast.get_collision_count() > 0:
    change_state.call("jump")

func walk():
  if persistent_state.foot_cast.get_collision_count() > 0:
    change_state.call("walk")

func run():
  if persistent_state.foot_cast.get_collision_count() > 0:
    change_state.call("run")

func idle():
  if persistent_state.foot_cast.get_collision_count() > 0:
    change_state.call("idle")
